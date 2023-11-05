# frozen_string_literal: true

require 'unicode/display_width'
require_relative 'natty-ui/wrapper'
require_relative 'natty-ui/ansi_wrapper'

#
# Module to create beautiful, nice, nifty, fancy, neat, pretty, cool, lovely,
# natty user interfaces for your CLI.
#
# It creates {Wrapper} instances which can optionally support ANSI. The UI
# consists of {Wrapper::Element}s and {Wrapper::Section}s for different
# {Wrapper::Features}.
#
module NattyUI
  class << self
    # @see .valid_in?
    # @return [IO] IO stream used to read input
    # @raise TypeError when a non-readable stream will be assigned
    attr_reader :in_stream

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
    # @raise TypeError when `stream` is not a writable stream
    def new(stream, ansi: :auto)
      unless valid_out?(stream)
        raise(TypeError, "writable IO required  - #{stream.inspect}")
      end
      wrapper_class(stream, ansi).__send__(:new, stream)
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

    # Calculate monospace (display) width of given String.
    # It respects Unicode character sizes inclusive emoji.
    #
    # @param [#to_s] str String to calculate
    # @return [Integer] the display size
    def display_width(str)
      str = str.to_s
      return 0 if str.empty?
      ret = Unicode::DisplayWidth.of(str, 1)
      ret -= emoji_extra_width_of(str) if defined?(Unicode::Emoji)
      [ret, 0].max
    end

    private

    def wrapper_class(stream, ansi)
      if (ansi == true) ||
           ((ansi == :auto) && (ENV['ANSI'] != '0') && stream.tty?)
        AnsiWrapper
      else
        Wrapper
      end
    end

    def emoji_extra_width_of(string)
      ret = 0
      string.scan(Unicode::Emoji::REGEX) do |emoji|
        ret += 2 * emoji.scan(EMOJI_MODIFIER_REGEX).size
        emoji.scan(EMOKI_ZWJ_REGEX) do |zwj_succ|
          ret += Unicode::DisplayWidth.of(zwj_succ, 1, {})
        end
      end
      ret
    end

    def stderr_is_stdout?
      STDOUT.tty? && STDERR.tty? && STDOUT.pos == STDERR.pos
    rescue IOError, SystemCallError
      false
    end
  end

  if defined?(Unicode::Emoji)
    EMOJI_MODIFIER_REGEX = /[#{Unicode::Emoji::EMOJI_MODIFIERS.pack('U*')}]/
    EMOKI_ZWJ_REGEX = /(?<=#{[Unicode::Emoji::ZWJ].pack('U')})./
    private_constant :EMOJI_MODIFIER_REGEX, :EMOKI_ZWJ_REGEX
  end

  # Instance for standard output.
  StdOut = new(STDOUT)

  # Instance for standard error output.
  StdErr = stderr_is_stdout? ? StdOut : new(STDERR)

  self.in_stream = STDIN
end
