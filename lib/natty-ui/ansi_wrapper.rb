# frozen_string_literal: true

require_relative 'ansi'
require_relative 'wrapper'

module NattyUI
  class AnsiWrapper < Wrapper
    def ansi? = true

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

    def prepare_print(args, kwargs)
      prefix = kwargs[:prefix] and prefix = NattyUI.embellish(prefix)
      suffix = kwargs[:suffix] and suffix = NattyUI.embellish(suffix)
      return ["#{prefix}#{suffix}"] if args.empty?
      NattyUI
        .each_line(
          *args.map! { NattyUI.embellish(_1) },
          max_width: find_max_width(kwargs, prefix, suffix)
        )
        .map { "#{prefix}#{_1}#{suffix}" }
    end

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
        unless block_given?
          wrapper.stream.flush
          return self
        end
        count = wrapper.lines_written
        begin
          yield(self)
        ensure
          count = wrapper.lines_written - count
          if count.nonzero?
            wrapper.stream << Ansi.cursor_line_up(count) <<
              Ansi::SCREEN_ERASE_BELOW
          end
          wrapper.stream.flush
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
        wrapper = parent.wrapper
        color = COLORS[glyph] || COLORS[:default]
        glyph = wrapper.glyph(glyph) || glyph
        prefix_width = NattyUI.display_width(glyph) + 1
        parent.puts(
          title,
          prefix: "#{glyph} #{color}",
          prefix_width: prefix_width,
          suffix: Ansi::RESET,
          suffix_width: 0
        )
        super(parent, prefix: ' ' * prefix_width, prefix_width: prefix_width)
      end

      COLORS = {
        default: Ansi[255],
        information: Ansi[255],
        warning: Ansi[221],
        error: Ansi[208],
        completed: Ansi[82],
        failed: Ansi[196],
        task: Ansi[39],
        query: Ansi[255]
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
