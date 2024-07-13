# frozen_string_literal: true

require_relative 'wrapper'

module NattyUI
  class AnsiWrapper < Wrapper
    def ansi? = true

    def puts(*args, **kwargs)
      return super if args.empty? || (animation = kwargs[:animation]).nil?

      prefix = kwargs[:prefix]
      if prefix && !prefix.empty?
        prefix = Text.embellish(prefix)
        prefix_width = kwargs[:prefix_width] || Text.width(prefix)
      else
        prefix = nil
        prefix_width = 0
      end
      kwargs[:prefix] = prefix
      kwargs[:prefix_width] = prefix_width

      suffix = kwargs[:suffix]
      suffix = suffix.empty? ? nil : Texct.embellish(suffix) if suffix

      mw = kwargs[:max_width]
      unless mw
        mw = screen_columns - prefix_width
        mw -= kwargs[:suffix_width] || Text.(suffix) if suffix
      end
      kwargs[:max_width] = mw

      (@stream << Ansi::CURSOR_HIDE).flush
      animation = LineAnimation[animation].new(@stream, kwargs)
      prefix = "#{Ansi::RESET}#{Ansi::CLL}#{prefix}"

      Text.each_line(
        args.map! { Text.embellish(Ansi.blemish(_1)) },
        mw
      ) do |line|
        @stream << prefix
        animation.print(line)
        (@stream << "#{prefix}#{line}#{suffix}\n").flush
        @lines_written += 1
      end

      (@stream << Ansi::CURSOR_SHOW).flush
      self
    end

    def page
      unless block_given?
        @stream.flush
        return self
      end
      (@stream << Ansi::SCREEN_BLANK).flush
      begin
        yield(self)
      ensure
        (@stream << Ansi::SCREEN_UNBLANK).flush
      end
    end

    def cls
      (@stream << Ansi::CLS).flush
      self
    end

    protected

    def prepare_print(args, kwargs)
      Text.prepare_print(args, kwargs, -> { screen_columns }) do |str|
        Text.embellish(str)
      end
    end

    def temp_func
      count = @lines_written
      lambda do
        if (c = @lines_written - count).nonzero?
          @stream << Ansi.cursor_prev_line(c) << Ansi.screen_erase(:below) <<
            Ansi::CURSOR_FIRST_COLUMN
          @lines_written -= c
        end
        @stream.flush
        self
      end
    end

    class Progress < Progress
      def draw(title, spinner)
        @msg =
          "#{@parent.prefix}#{Ansi[:bold, 39]}➔#{Ansi[:reset, 39]} " \
            "#{title}#{Ansi::RESET} "
        (wrapper.stream << @msg << Ansi::CURSOR_HIDE).flush
        @msg = "#{Ansi::CLL}#{@msg}"
        return @msg << BAR_COLOR if @max_value
        spinner_color = Ansi[:bold, 220]
        @spinner =
          Enumerator.new do |y|
            spinner.each_char { y << "#{spinner_color}#{_1}" } while true
          end
      end

      def redraw
        (wrapper.stream << @msg << (@max_value ? fullbar : @spinner.next)).flush
      end

      def end_draw = (wrapper.stream << Ansi::CLL << Ansi::CURSOR_SHOW).flush

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
            wrapper.stream << Ansi.cursor_prev_line(count) <<
              Ansi.display(:erase_below)
          end
          wrapper.stream.flush
        end
      end
    end

    class Section < Section
      include Temporary
    end

    class Quote < Quote
      include Temporary

      def initialize(...)
        super
        @prefix = "#{Ansi[39]}#{@prefix}#{Ansi::RESET}"
      end
    end

    class Framed < Framed
      def color(str) = "#{Ansi[39]}#{str}#{Ansi::RESET}"

      def init(deco)
        @prefix = "#{color(deco[0])} "
        @suffix = "#{Ansi.cursor_column(parent.rcol)}#{color(deco[4])}"
        aw = @parent.available_width - 2
        parent.puts(color("#{deco[1]}#{deco[2] * aw}#{deco[3]}"))
        @finish = color("#{deco[5]}#{deco[6] * aw}#{deco[7]}")
      end
    end

    class Message < Section
      protected

      def initialize(parent, title:, glyph:)
        wrapper = parent.wrapper
        color = COLORS[glyph] || COLORS[:default]
        glyph = wrapper.glyph(glyph) || glyph
        prefix_width = Text.width(glyph) + 1
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

    class Task < Message
      include ProgressAttributes
      include TaskMethods
    end
  end

  private_constant :AnsiWrapper
end
