# frozen_string_literal: true

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
      reset = false
      str =
        str_translate(str) do |match|
          if match[0] == '/'
            next "[[#{match[1..]}]]" if match.size > 1
            reset = false
            next Ansi::RESET
          end
          ansi = Ansi.try_convert(match)
          ansi ? reset = ansi : "[[#{match}]]"
        end
      reset ? "#{str}#{Ansi::RESET}" : str
    end

    # Remove embedded attribute descriptions from given string.
    #
    # @param [#to_s] str string to edit
    # @param [:keep,:remove] ansi keep or remove ANSI codes too
    # @return [String] edited string
    def plain(str, ansi: :keep)
      str =
        str_translate(str) do |match|
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
      str = plain(str)
      return 0 if str.empty?
      str = str.encode(Encoding::UTF_8) if str.encoding != Encoding::UTF_8
      width = 0
      in_zero_width = false
      str.scan(WIDTH_SCANNER) do |np_start, np_end, _csi, _osc, gc|
        if in_zero_width
          in_zero_width = false if np_end
          next
        end
        next in_zero_width = true if np_start
        width += str_char_width(gc) if gc
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
        return
      end
      return if (max_width = max_width.to_i) <= 0
      strs.each do |str|
        str
          .to_s
          .each_line(chomp: true) do |line|
            next yield(line) if line.empty?
            str_split(line, max_width, line.encoding).each(&block)
          end
      end
      nil
    end

    # Returns first line of a given text.
    # Optionally limit the line width to given `max_width`.
    #
    # @param [#to_s] text
    # @param [#to_i, nil] max_width maximum line width to return
    # @return [String] first text line
    def first_line(text, max_width: nil)
      text = text.to_s.each_line(chomp: true).first or return +''
      return text if max_width.nil? || text.empty?
      seq = String.new(encoding: text.encoding)
      return seq if (max_width = max_width.to_i) <= 0
      line = seq.dup
      width = 0
      in_zero_width = false
      text = text.encode(Encoding::UTF_8) if text.encoding != Encoding::UTF_8
      text.scan(WIDTH_SCANNER) do |np_start, np_end, csi, osc, gc|
        next in_zero_width = (line << "\1") if np_start
        next in_zero_width = !(line << "\2") if np_end
        next (line << osc) && (seq << osc) if osc
        if csi
          line << csi
          next if in_zero_width
          next csi == "\e[m" || csi == "\e[0m" ? seq.clear : seq << csi
        end
        next line << gc if in_zero_width
        cw = str_char_width(gc)
        return line if (width += cw) > max_width
        line << gc
      end
      line
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

    def str_translate(str)
      return +'' if (str = str.to_s).empty?
      str.gsub(/(\[\[((?~\]\]))\]\])/) { yield(Regexp.last_match[2]) }
    end

    def str_split(str, max_width, encoding)
      lines = [(seq = String.new(encoding: encoding)).dup]
      width = 0
      in_zero_width = false
      str = str.encode(Encoding::UTF_8) if str.encoding != Encoding::UTF_8
      str.scan(WIDTH_SCANNER) do |np_start, np_end, csi, osc, gc|
        next in_zero_width = (lines.last << "\1") if np_start
        next in_zero_width = !(lines.last << "\2") if np_end
        next (lines.last << osc) && (seq << osc) if osc
        if csi
          lines.last << csi
          next if in_zero_width
          next csi == "\e[m" || csi == "\e[0m" ? seq.clear : seq << csi
        end
        next lines.last << gc if in_zero_width
        cw = str_char_width(gc)
        if (width += cw) > max_width
          width = cw
          lines << seq.dup
        end
        lines.last << gc
      end
      lines
    end

    def str_char_width(char)
      ord = char.ord
      return SPECIAL_CHARS[ord] || 2 if ord <= 0x1f
      return 1 if ord <= 0x7e
      size = EastAsianWidth[ord]
      return @ambiguous_char_width if size == -1
      if size == 1 && char.size >= 2
        sco = char[1].ord
        # Halfwidth Dakuten Handakuten
        return sco == 0xff9e || sco == 0xff9f ? 2 : 1
      end
      size
    end
  end

  WIDTH_SCANNER = /\G(?:(\1)|(\2)|(#{Ansi::CSI})|(#{Ansi::OSC})|(\X))/

  SPECIAL_CHARS = {
    0x00 => 0,
    0x01 => 1,
    0x02 => 1,
    0x03 => 1,
    0x04 => 1,
    0x05 => 0,
    0x06 => 1,
    0x07 => 0,
    0x08 => 0,
    0x09 => 8,
    0x0a => 0,
    0x0b => 0,
    0x0c => 0,
    0x0d => 0,
    0x0e => 0,
    0x0f => 0,
    0x10 => 1,
    0x11 => 1,
    0x12 => 1,
    0x13 => 1,
    0x14 => 1,
    0x15 => 1,
    0x16 => 1,
    0x17 => 1,
    0x18 => 1,
    0x19 => 1,
    0x1a => 1,
    0x1b => 1,
    0x1c => 1,
    0x1d => 1,
    0x1e => 1,
    0x1f => 1
  }.compare_by_identity.freeze
  @ambiguous_char_width = 1

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
