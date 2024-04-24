# frozen_string_literal: true

require_relative 'ansi'
require_relative 'wrapper'

module NattyUI
  class AnsiWrapper < Wrapper
    def ansi? = true

    def puts(*args, **kwargs)
      return super() if args.empty?

      prefix = kwargs[:prefix]
      suffix = kwargs[:suffix]

      max_width =
        kwargs[:max_width] ||
          (
            screen_columns -
              (
                if prefix
                  kwargs[:prefix_width] || _cleared_width(prefix)
                else
                  0
                end
              ) -
              (
                if suffix
                  kwargs[:suffix_width] || _cleared_width(suffix)
                else
                  0
                end
              )
          )

      prefix = NattyUI.embellish(prefix) if prefix
      suffix = NattyUI.embellish(suffix) if suffix

      args.map! { NattyUI.embellish(_1) }
      NattyUI.each_line(*args, max_width: max_width) do |line|
        @stream.puts("#{prefix}#{line}#{suffix}")
        @lines_written += 1
      end
      @stream.flush
      self
    end

    def page
      unless block_given?
        @stream.flush
        return self
      end
      (@stream << Ansi::BLANK_SLATE).flush
      begin
        yield(self)
      ensure
        (@stream << Ansi::UNBLANK_SLATE).flush
      end
    end

    def cls
      (@stream << Ansi::CURSOR_HOME << Ansi::SCREEN_ERASE).flush
      self
    end

    protected

    def temp_func
      count = @lines_written
      lambda do
        count = @lines_written - count
        if count.nonzero?
          @stream << Ansi.cursor_line_up(count) << Ansi::SCREEN_ERASE_BELOW
          @lines_written -= count
        end
        @stream.flush
        self
      end
    end

    class HorizontalRule < HorizontalRule
      def call(symbol)
        msg, max_width = determine(symbol)
        return @parent.puts unless msg
        @parent.puts(
          msg,
          max_width: max_width,
          prefix: Ansi[39],
          suffix: Ansi::RESET
        )
      end
    end
    private_constant :HorizontalRule

    class Heading < Heading
      def call(title, enclose)
        @parent.puts(
          title,
          prefix: "#{Ansi[39]}#{enclose} #{Ansi[:bold, 255]}",
          suffix: " #{Ansi[:normal, 39]}#{enclose}#{Ansi::RESET}",
          max_width: available_width - 2 - (enclose.size * 2)
        )
      end
    end
    private_constant :Heading

    class Ask < Ask
      def draw(title)
        (
          wrapper.stream << @parent.prefix << Ansi[:bold, 39] <<
            find_glyph(:query) << Ansi[:reset, 39] << ' ' << title <<
            Ansi::RESET << ' '
        ).flush
      end

      def finish = (wrapper.stream << Ansi::LINE_CLEAR).flush
    end
    private_constant :Ask

    class Request < Request
      def prompt(question)
        "#{@parent.prefix}#{Ansi[:bold, 39]}#{find_glyph(:query)}#{Ansi[:reset, 39]} " \
          "#{question}:#{Ansi::RESET} "
      end

      def finish
        (
          wrapper.stream << Ansi::CURSOR_LINE_UP << Ansi::LINE_ERASE_TO_END
        ).flush
      end
    end
    private_constant :Request

    class Progress < Progress
      def draw(title)
        @msg =
          "#{@parent.prefix}#{Ansi[:bold, 39]}➔#{Ansi[:reset, 39]} " \
            "#{title}#{Ansi::RESET} "
        (wrapper.stream << @msg << Ansi::CURSOR_HIDE).flush
        @msg = "#{Ansi::LINE_CLEAR}#{@msg}"
        return @msg << BAR_COLOR if @max_value
        @msg << Ansi[:bold, 220]
        @indicator = 0
      end

      def redraw
        (wrapper.stream << @msg << (@max_value ? fullbar : indicator)).flush
      end

      def end_draw
        (wrapper.stream << Ansi::LINE_CLEAR << Ansi::CURSOR_SHOW).flush
      end

      def indicator = '◐◓◑◒'[(@indicator += 1) % 4]

      def fullbar
        percent = @value / @max_value
        count = (30 * percent).to_i
        mv = max_value.to_i.to_s
        "#{'█' * count}#{BAR_BACK}#{'▁' * (30 - count)}" \
          "#{BAR_INK} #{value.to_i.to_s.rjust(mv.size)}/#{mv} " \
          "(#{(percent * 100).round(2).to_s.rjust(6)})"
      end

      BAR_COLOR = Ansi[39, 295].freeze
      BAR_BACK = Ansi[236, 492].freeze
      BAR_INK = Ansi[:bold, 255, :on_default].freeze
    end
    private_constant :Progress

    module Temporary
      def temporary
        stream = wrapper.stream
        unless block_given?
          stream.flush
          return self
        end
        count = wrapper.lines_written
        begin
          yield(self)
        ensure
          count = wrapper.lines_written - count
          if count.nonzero?
            stream << Ansi.cursor_line_up(count) << Ansi::SCREEN_ERASE_BELOW
          end
          stream.flush
        end
      end
    end
    private_constant :Temporary

    class Section < Section
      include Temporary
    end
    private_constant :Section

    class Quote < Quote
      include Temporary

      def initialize(...)
        super
        @prefix = "#{Ansi[39]}#{@prefix}#{Ansi::RESET}"
      end
    end
    private_constant :Quote

    class Framed < Framed
      def color(str) = "#{Ansi[39]}#{str}#{Ansi::RESET}"
    end
    private_constant :Framed

    class Message < Section
      protected

      def initialize(parent, title:, glyph:)
        color = COLORS[glyph] || COLORS[:default]
        glyph = find_glyph(glyph) || glyph
        prefix_width = _cleared_width(glyph) + 1
        parent.puts(
          title,
          prefix: "#{color}#{glyph} #{color}",
          prefix_width: prefix_width,
          suffix: Ansi::RESET,
          suffix_width: 0
        )
        super(parent, prefix: ' ' * prefix_width, prefix_width: prefix_width)
      end

      COLORS = {
        default: Ansi[:bold, 255],
        information: Ansi[:bold, 119],
        warning: Ansi[:bold, 221],
        error: Ansi[:bold, 208],
        completed: Ansi[:bold, 82],
        failed: Ansi[:bold, 196],
        task: Ansi[:bold, 39],
        query: Ansi[:bold, 39]
      }.compare_by_identity.freeze
    end
    private_constant :Message

    class Task < Message
      include ProgressAttributes
      include TaskMethods
    end
    private_constant :Task
  end

  private_constant :AnsiWrapper
end
