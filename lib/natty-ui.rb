# frozen_string_literal: true

require_relative 'natty-ui/ansi'
require_relative 'natty-ui/ansi_constants'
require_relative 'natty-ui/wrapper'
require_relative 'natty-ui/ansi_wrapper'

#
# Module to create beautiful, nice, nifty, fancy, neat, pretty, cool, lovely,
# natty user interfaces for your CLI application.
#
# It creates {Wrapper} instances which can optionally support ANSI. The UI
# consists of {Wrapper::Element}s and {Wrapper::Section}s for different
# {Features}.
#
module NattyUI
  class << self
    # @see .valid_in?
    # @return [IO] IO stream used to read input
    # @raise [TypeError] when a non-readable stream will be assigned
    attr_reader :in_stream

    # @return [Wrapper, Wrapper::Element] active UI element
    attr_reader :element

    # @param [IO] stream to read input
    def in_stream=(stream)
      unless valid_in?(stream)
        raise(TypeError, "readable IO required  - #{stream.inspect}")
      end
      @in_stream = stream
    end

    # Create a wrapper for given `stream`.
    #
    # @see .valid_out?
    #
    # @param [IO] stream valid out stream
    # @param [Boolean, :auto] ansi whether ANSI should be supported
    #   or automatically selected
    # @return [Wrapper] wrapper for the given `stream`
    # @raise [TypeError] when `stream` is not a writable stream
    def new(stream, ansi: :auto)
      unless valid_out?(stream)
        raise(TypeError, "writable IO required  - #{stream.inspect}")
      end
      wrapper_class(stream, ansi).__send__(:new, stream)
    end

    # Test if the given `stream` can be used for input
    #
    # @param [IO] stream IO instance to test
    # @return [Boolean] whether if the given stream is usable
    def valid_in?(stream)
      (stream.is_a?(IO) && !stream.closed? && stream.stat.readable?) ||
        (stream.is_a?(StringIO) && !stream.closed_read?)
    rescue StandardError
      false
    end

    # Test if the given `stream` can be used for output
    #
    # @param [IO] stream IO instance to test
    # @return [Boolean] whether if the given stream is usable
    def valid_out?(stream)
      (stream.is_a?(IO) && !stream.closed? && stream.stat.writable?) ||
        (stream.is_a?(StringIO) && !stream.closed_write?)
    rescue StandardError
      false
    end

    # Translate embedded attribute descriptions into ANSI control codes.
    #
    # @param [#to_s] str string to edit
    # @return [String] edited string
    def embellish(str)
      return +'' if (str = str.to_s).empty?
      reset = false
      str =
        str.gsub(/(\[\[((?~\]\]))\]\])/) do
          match = Regexp.last_match[2]
          if match[0] == '/'
            next "[[#{match[1..]}]]" if match.size > 1
            reset = false
            Ansi::RESET
          else
            ansi = Ansi.try_convert(match)
            ansi ? reset = ansi : "[[#{match}]]"
          end
        end
      reset ? "#{str}#{Ansi::RESET}" : str
    end

    # Remove embedded attribute descriptions from given string.
    #
    # @param [#to_s] str string to edit
    # @param [:keep,:remove] ansi keep or remove ANSI codes too
    # @return [String] edited string
    def plain(str, ansi: :keep)
      return +'' if (str = str.to_s).empty?
      str =
        str.gsub(/(\[\[((?~\]\]))\]\])/) do
          match = Regexp.last_match[2]
          next match.size == 1 ? nil : "[[#{match[1..]}]]" if match[0] == '/'
          Ansi.try_convert(match) ? nil : "[[#{match}]]"
        end
      ansi == :keep ? str : Ansi.blemish(str)
    end

    # Calculate monospace (display) width of given String.
    # It respects Unicode character sizes inclusive emoji.
    #
    # @param [#to_s] str string to calculate
    # @return [Integer] the display size
    def display_width(str)
      str = plain(str).encode(Encoding::UTF_8)
      return 0 if str.empty?
      width = 0
      in_zero_width = false
      str.scan(Ansi::WIDTH_SCANNER) do |np_start, np_end, _csi, _osc, gc|
        if in_zero_width
          in_zero_width = false if np_end
          next
        end
        next in_zero_width = true if np_start
        width += get_mbchar_width(gc) if gc
      end
      width
    end

    # Convert given arguments into strings and yield each line.
    # Optionally limit the line width to given `max_width`.
    #
    # @overload each_line(..., max_width: nil)
    #   @param [#to_s] ... objects converted to text lines
    #   @param [#to_i, nil] max_width maximum line width
    #   @yieldparam [String] line string line
    #   @return [nil]
    # @overload each_line(..., max_width: nil)
    #   @param [#to_s] ... objects converted to text lines
    #   @param [#to_i, nil] max_width maximum line width
    #   @return [Enumerator] line enumerator
    def each_line(*strs, max_width: nil, &block)
      return to_enum(__method__, *strs, max_width: max_width) unless block
      if max_width.nil?
        strs.each { _1.to_s.each_line(chomp: true, &block) }
        return nil
      end
      return if (max_width = max_width.to_i) <= 0
      strs.each do |str|
        str
          .to_s
          .each_line(chomp: true) do |line|
            next yield(line) if line.empty?
            split_by_width(line, max_width, line.encoding).each(&block)
          end
      end
      nil
    end

    # Read next raw key (keyboard input) from {in_stream}.
    #
    # The input will be returned as named key codes like "Ctrl+C" by default.
    # This can be changed by the `mode` parameter:
    #
    # - `:named` - name if available (fallback to raw)
    # - `:raw` - key code "as is"
    # - `:both` - key code and name if available
    #
    # @param [:named, :raw, :both] mode modfies the result
    # @return [String] read key
    def read_key(mode: :named)
      return @in_stream.getch unless defined?(@in_stream.getc)
      return @in_stream.getc unless defined?(@in_stream.raw)
      @in_stream.raw do |raw_stream|
        key = raw_stream.getc
        while (nc = raw_stream.read_nonblock(1, exception: false))
          nc.is_a?(String) ? key += nc : break
        end
        return key if mode == :raw
        return key, KEY_MAP[key]&.dup if mode == :both
        KEY_MAP[key]&.dup || key
      end
    rescue Interrupt, SystemCallError
      nil
    end

    private

    def wrapper_class(stream, ansi)
      return AnsiWrapper if ansi == true
      return Wrapper if ansi == false || ENV.key?('NO_COLOR')
      return AnsiWrapper if ENV['ANSI'] == '1'
      return Wrapper if ENV['TERM'] == 'dumb'
      stream.tty? ? AnsiWrapper : Wrapper
    end

    def stderr_is_stdout?
      STDOUT.tty? && STDERR.tty? && STDOUT.pos == STDERR.pos
    rescue IOError, SystemCallError
      false
    end

    def split_by_width(str, max_width, encoding)
      lines = [(seq = String.new(encoding: encoding)).dup]
      width = 0
      in_zero_width = false
      str
        .encode(Encoding::UTF_8)
        .scan(Ansi::WIDTH_SCANNER) do |np_start, np_end, csi, osc, gc|
          if np_start
            lines.last << "\1"
            next in_zero_width = true
          end
          if np_end
            lines.last << "\2"
            next in_zero_width = false
          end
          if osc
            lines.last << osc
            next seq << osc
          end
          if csi
            lines.last << csi
            next if in_zero_width
            next csi == "\e[m" || csi == "\e[0m" ? seq.clear : seq << csi
          end
          next lines.last << gc if in_zero_width
          mbchar_width = get_mbchar_width(gc)
          if (width += mbchar_width) > max_width
            width = mbchar_width
            lines << seq.dup
          end
          lines.last << gc
        end
      lines
    end

    def get_mbchar_width(mbchar)
      ord = mbchar.ord
      return 2 if ord <= 0x1F
      return 1 if ord <= 0x7E
      size = EastAsianWidth[ord]
      return 1 if size == -1 # ambiguous width
      if size == 1 && mbchar.size >= 2
        sco = mbchar[1].ord
        # Halfwidth Dakuten Handakuten
        return sco == 0xFF9E || sco == 0xFF9F ? 2 : 1
      end
      size
    end
  end

  # Instance for standard output.
  StdOut = new(STDOUT)

  # Instance for standard error output.
  StdErr = stderr_is_stdout? ? StdOut : new(STDERR)

  dir = __dir__
  autoload(:LineAnimation, File.join(dir, 'natty-ui', 'line_animation'))
  autoload(:EastAsianWidth, File.join(dir, 'natty-ui', 'east_asian_width'))
  autoload(:KEY_MAP, File.join(dir, 'natty-ui', 'key_map'))

  private_constant :WIDTH_SCANNER, :SPECIAL_CHARS, :EastAsianWidth
  private_constant :LineAnimation, :KEY_MAP

  @element = StdOut
  self.in_stream = STDIN
end

# @!visibility private
module Kernel
  # @see NattyUI.element
  # @return [NattyUI::Wrapper, NattyUI::Wrapper::Element] active UI element
  def ui = NattyUI.element unless defined?(ui)
end
