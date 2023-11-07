# frozen_string_literal: true

require 'stringio'
require_relative 'wrapper/ask'
require_relative 'wrapper/framed'
require_relative 'wrapper/heading'
require_relative 'wrapper/message'
require_relative 'wrapper/progress'
require_relative 'wrapper/query'
require_relative 'wrapper/section'
require_relative 'wrapper/task'

module NattyUI
  #
  # Helper class to wrap an output stream and implement all {Features}.
  #
  class Wrapper
    include Features

    # @return [IO] IO stream used for output
    attr_reader :stream

    # @attribute [r] ansi?
    # @return [Boolean] whether ANSI is supported
    def ansi? = false

    # @attribute [r] screen_size
    # @return [[Integer, Integer]] screen size as rows and columns
    def screen_size
      return @stream.winsize if @ws
      [ENV['LINES'].to_i.nonzero? || 25, ENV['COLUMNS'].to_i.nonzero? || 80]
    end

    # @attribute [r] screen_rows
    # @return [Integer] number of screen rows
    def screen_rows
      @ws ? @stream.winsize[0] : (ENV['LINES'].to_i.nonzero? || 25)
    end

    # @attribute [r] screen_columns
    # @return [Integer] number of screen columns
    def screen_columns
      @ws ? @stream.winsize[-1] : (ENV['COLUMNS'].to_i.nonzero? || 80)
    end

    # @!group Tool functions

    # Print given arguments as lines to the output stream.
    #
    # @overload puts(...)
    #   @param [#to_s] ... objects to print
    #   @comment @param [#to_s, nil] prefix line prefix
    #   @comment @param [#to_s, nil] suffix line suffix
    #   @return [Wrapper] itself
    def puts(*args, prefix: nil, suffix: nil)
      if args.empty?
        @stream.puts(embellish("#{prefix}#{suffix}"))
        @lines_written += 1
      else
        StringIO.open do |io|
          io.puts(*args)
          io.rewind
          io.each(chomp: true) do |line|
            @stream.puts(embellish("#{prefix}#{line}#{suffix}"))
            @lines_written += 1
          end
        end
      end
      @stream.flush
      self
    end
    alias add puts

    # Add at least one empty line
    #
    # @param [#to_i] lines count of lines
    # @return [Wrapper] itself
    def space(lines = 1)
      lines = [lines.to_i, 1].max
      @stream.puts(*Array.new(lines))
      @lines_written += lines
      @stream.flush
      self
    end

    # @note The screen manipulation is only available in ANSI mode see {#ansi?}
    #
    # Saves current screen, deletes all screen content and moves the cursor
    # to the top left screen corner. It restores the screen after the block.
    #
    # @example
    #   UI.page do |page|
    #     page.info('This message will disappear in 5 seconds!')
    #     sleep 5
    #   end
    #
    # @yield [Wrapper] itself
    # @return [Object] block result
    def page
      block_given? ? yield(self) : self
    ensure
      @stream.flush
    end

    # @note The screen manipulation is only available in ANSI mode see {#ansi?}
    #
    # Resets the part of the screen written below the current output line when
    # the given block ended.
    #
    # @example
    #   UI.temporary do |temp|
    #     temp.info('This message will disappear in 5 seconds!')
    #     sleep 5
    #   end
    #
    # @yield [Wrapper] itself
    # @return [Object] block result
    def temporary
      block_given? ? yield(self) : self
    ensure
      @stream.flush
    end

    # @!endgroup

    # @!visibility private
    attr_reader :lines_written

    # @!visibility private
    alias inspect to_s

    protected

    def initialize(stream)
      @stream = stream
      @lines_written = 0
      @ws = ansi? && stream.respond_to?(:winsize) && stream.winsize
    end

    def wrapper = self
    def prefix = nil
    alias suffix prefix
    def embellish(obj) = obj&.to_s&.gsub(RE_EMBED, '')

    RE_EMBED = /({{:((?~:}})):}})/
    private_constant :RE_EMBED

    private_class_method :new
  end
end
