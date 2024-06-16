# frozen_string_literal: true

unless defined?(Reline)
  # load the Reline::Unicode part only
  # @!visibility private
  module Reline
    # @!visibility private
    def self.ambiguous_width = 1
  end
  require 'reline/unicode'
end
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

    # Translate embedded attribute descriptions into ANSI control codes.
    #
    # @param [#to_s] str string to edit
    # @return [String] edited string
    def embellish(str)
      return +'' if (str = str.to_s).empty?
      reset = false
      ret =
        str.gsub(/(\[\[((?~\]\]))\]\])/) do
          match = Regexp.last_match[2]
          unless match.delete_prefix!('/')
            ansi = Ansi.try_convert(match)
            next ansi ? reset = ansi : "[[#{match}]]"
          end
          match.empty? or next "[[#{match}]]"
          reset = false
          Ansi::RESET
        end
      reset ? "#{ret}#{Ansi::RESET}" : ret
    end

    # Remove embedded attribute descriptions from given string.
    #
    # @param [#to_s] str string to edit
    # @param [:keep,:remove] ansi keep or remove ANSI codes too
    # @return [String] edited string
    def plain(str, ansi: :keep)
      str =
        str
          .to_s
          .gsub(/(\[\[((?~\]\]))\]\])/) do
            match = Regexp.last_match[2]
            if match.delete_prefix!('/')
              next match.empty? ? nil : "[[#{match}]]"
            end
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
      return 0 if (str = str.to_s).empty?
      Reline::Unicode.calculate_width(plain(str), true)
    end

    # Convert given arguments into strings and yield each line.
    # Optionally limit the line width to given `max_width`.
    #
    # @overload each_line(..., max_width: nil)
    #   @param [#to_s] ... objects to print
    #   @param [#to_i, nil] max_width maximum line width
    #   @yieldparam [String] line string line
    #   @return [nil]
    # @overload each_line(..., max_width: nil)
    #   @param [#to_s] ... objects to print
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
            Reline::Unicode.split_by_width(line, max_width)[0].each do |part|
              yield(part) if part
            end
          end
      end
      nil
    end

    # Read next raw key (keyboard input) from {in_stream}.
    #
    # @return [String] read key
    def read_key
      return @in_stream.getch unless defined?(@in_stream.getc)
      return @in_stream.getc unless defined?(@in_stream.raw)
      @in_stream.raw do |raw|
        key = raw.getc
        while (nc = raw.read_nonblock(1, exception: false))
          nc.is_a?(String) ? key += nc : break
        end
        key
      end
    end

    private

    def wrapper_class(stream, ansi)
      return AnsiWrapper if ansi == true
      if ansi == false || ENV.key?('NO_COLOR') || ENV['TERM'] == 'dumb'
        return Wrapper
      end
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

  @element = StdOut
  self.in_stream = STDIN
end

# @see NattyUI.element
# @return [NattyUI::Wrapper, NattyUI::Wrapper::Element] active UI element
def ui = NattyUI.element unless defined?(ui)
