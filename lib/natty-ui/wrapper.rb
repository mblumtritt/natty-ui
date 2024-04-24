# frozen_string_literal: true

require 'io/console'
require_relative 'wrapper/ask'
require_relative 'wrapper/framed'
require_relative 'wrapper/heading'
require_relative 'wrapper/horizontal_rule'
require_relative 'wrapper/list_in_columns'
require_relative 'wrapper/message'
require_relative 'wrapper/progress'
require_relative 'wrapper/query'
require_relative 'wrapper/quote'
require_relative 'wrapper/request'
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
    def screen_size = (@screen_size ||= determine_screen_size)

    # @attribute [r] screen_rows
    # @return [Integer] number of screen rows
    def screen_rows = screen_size[0]

    # @attribute [r] screen_columns
    # @return [Integer] number of screen columns
    def screen_columns = screen_size[1]

    # @!group Tool functions

    # Print given arguments as lines to the output stream.
    # Optionally limit the line width to given `max_width`.
    #
    # @overload puts(...)
    #   @param [#to_s] ... objects to print
    #   @return [Wrapper] itself
    def puts(*args, **kwargs)
      prefix = kwargs[:prefix]
      suffix = kwargs[:suffix]

      if args.empty?
        @stream.puts("#{prefix}#{suffix}")
        @lines_written += 1
        @stream.flush
        return self
      end

      max_width =
        kwargs[:max_width] ||
          (
            screen_columns -
              (
                if prefix
                  kwargs[:prefix_width] || NattyUI.display_width(prefix)
                else
                  0
                end
              ) -
              (
                if suffix
                  kwargs[:suffix_width] || NattyUI.display_width(suffix)
                else
                  0
                end
              )
          )

      args.map! { Ansi.blemish(NattyUI.plain(_1)) }
      NattyUI.each_line(*args, max_width: max_width) do |line|
        @stream.puts("#{prefix}#{line}#{suffix}")
        @lines_written += 1
      end
      @stream.flush
      self
    end

    # Add at least one empty line
    #
    # @param [#to_i] lines count of lines
    # @return [Wrapper] itself
    def space(lines = 1)
      lines = [1, lines.to_i].max
      (@stream << ("\n" * lines)).flush
      @lines_written += lines
      self
    end

    def cls = self

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
    # @overload temporary
    #   @return [Proc] a function to reset the screen
    #
    # @overload temporary
    #   @yield [Wrapper] itself
    #   @return [Object] block result
    def temporary
      func = temp_func
      return func unless block_given?
      begin
        yield(self)
      ensure
        func.call
      end
    end

    # @!endgroup

    # @!visibility private
    attr_reader :lines_written

    # @!visibility private
    alias inspect to_s

    def wrapper = self

    # @!visibility private
    alias available_width screen_columns

    # @!visibility private
    def prefix = ''

    protected

    def temp_func
      lambda do
        @stream.flush
        self
      end
    end

    def initialize(stream)
      @stream = stream
      @lines_written = 0
    end

    private_class_method :new

    private

    def determine_screen_size
      return @stream.winsize if @ws
      if @ws.nil?
        ret = try_fetch_winsize
        if ret
          @ws = true
          Signal.trap('WINCH') { @screen_size = nil }
          return ret
        end
        @ws = false
      end
      [ENV['LINES'].to_i.nonzero? || 24, ENV['COLUMNS'].to_i.nonzero? || 80]
    end

    def try_fetch_winsize
      return unless @stream.respond_to?(:winsize)
      ret = @stream.winsize
      ret&.all?(&:positive?) ? ret : nil
    rescue Errno::ENOTTY
      nil
    end
  end
end
