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

    # Print given arguments line-wise to the output stream.
    #
    # @overload puts(...)
    #   @param [#to_s] ... objects to print
    #   @return [Wrapper] itself
    def puts(*args, **kwargs)
      args = prepare_print(args, kwargs)
      @lines_written += args.size
      @stream.puts(args)
      @stream.flush
      self
    end

    # Print given arguments to the output stream.
    #
    # @overload print(...)
    #   @param [#to_s] ... objects to print
    #   @return [Wrapper] itself
    def print(*args, **kwargs)
      args = prepare_print(args, kwargs).to_a
      @lines_written += args.size
      @lines_written -= 1
      @stream.print(args.join("\n"))
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

    # Clear Screen
    #
    # @return [Wrapper] itself
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

    # @return [Array<Symbol>] available glyph names
    def glyph_names = GLYPHS.keys

    #
    # Get a pre-defined glyph
    #
    # @param [Symbol] name glyph name
    # @return [String] the named glyph
    # @return [nil] when glyph is not defined
    def glyph(name) = GLYPHS[name]

    #
    # Get a pre-defined glyph attribute
    #
    # @overload glyph_attribute(name)
    #   @param [Symbol] name glyph name
    #   @return [String] ANSI attributes for the named glyph
    #   @return [nil] when ANSI is not supported
    def glyph_attribute(_name) = nil

    protected

    def prepare_print(args, kwargs)
      prefix = kwargs[:prefix]
      suffix = kwargs[:suffix]
      return ["#{prefix}#{suffix}"] if args.empty?
      NattyUI
        .each_line(
          *args.map! { Ansi.blemish(NattyUI.plain(_1)) },
          max_width:
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
        )
        .map { "#{prefix}#{_1}#{suffix}" }
    end

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
    rescue SystemCallError
      nil
    end

    GLYPHS = {
      default: '•',
      information: '𝒊',
      warning: '!',
      error: '𝙓',
      completed: '✓',
      failed: '𝑭',
      task: '➔',
      query: '▸'
    }.compare_by_identity.freeze
    # GLYPHS = {
    #   default: '●',
    #   information: '🅸 ',
    #   warning: '🆆 ',
    #   error: '🅴 ',
    #   completed: '✓',
    #   failed: '🅵 ',
    #   task: '➔',
    #   query: '🆀 '
    # }.compare_by_identity.freeze
    private_constant :GLYPHS
  end
end
