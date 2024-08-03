# frozen_string_literal: true

require_relative 'natty-ui/text'
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
    def embellish(str) = Text.embellish(str)

    # Remove embedded attribute descriptions from given string.
    #
    # @param [#to_s] str string to edit
    # @param [:keep,:remove] ansi keep or remove ANSI codes too
    # @return [String] edited string
    def plain(str, ansi: :keep)
      ansi == :keep ? Text.plain_but_ansi(str) : Text.plain(str)
    end

    # Calculate monospace (display) width of given String.
    # It respects Unicode character sizes inclusive emoji.
    #
    # @param [#to_s] str string to calculate
    # @return [Integer] the display size
    def display_width(str) = Text.width(str)

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
      return Text.simple_each_line(strs, &block) unless max_width
      Text.each_line(strs, max_width, &block)
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
  end

  # Instance for standard output.
  StdOut = new(STDOUT)

  # Instance for standard error output.
  StdErr = stderr_is_stdout? ? StdOut : new(STDERR)

  dir = __dir__
  autoload(:Animation, File.join(dir, 'natty-ui', 'animation'))
  autoload(:Frame, File.join(dir, 'natty-ui', 'frame'))
  autoload(:Glyph, File.join(dir, 'natty-ui', 'glyph'))
  autoload(:KEY_MAP, File.join(dir, 'natty-ui', 'key_map'))
  autoload(:Spinner, File.join(dir, 'natty-ui', 'spinner'))

  private_constant :Animation, :KEY_MAP

  @element = StdOut
  self.in_stream = STDIN
end

# @!visibility private
module Kernel
  # @see NattyUI.element
  # @return [NattyUI::Wrapper, NattyUI::Wrapper::Element] active UI element
  def ui = NattyUI.element unless defined?(ui)
end
