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

    protected

    def embellish(obj) = (obj = NattyUI.embellish(obj)).empty? ? nil : obj

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

    class Message < Message
      protected

      def prefix_info(glyph)
        color = COLOR[glyph] || 'ff'
        glyph = wrapper.glyph(glyph)
        [
          _cleared_width(glyph) + 1,
          { prefix: "#{glyph} [[bold #{color}]]", suffix: Ansi::RESET }
        ]
      end

      COLOR = {
        information: '2d',
        warning: 'dd',
        error: 'd0',
        completed: '52',
        failed: 'c4',
        query: '0b',
        task: '51'
      }.compare_by_identity.freeze
    end
    private_constant :Message

    class Section < Section
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

      protected def initialize(parent, prefix_attr: nil, **opts)
        super
        return unless @prefix && prefix_attr
        @prefix = Ansi.embellish(@prefix, *prefix_attr)
      end
    end
    private_constant :Section

    class Framed < Section
      protected

      def initialize(parent, title:, type:, **opts)
        @parent = parent
        title = title.to_s.tr("\r\n\t", '')
        topl, topr, botl, botr, hor, vert = *components(type)
        width = available_width
        rcount = [0, width - _cleared_width(title) - 6].max
        parent.puts(
          "#{COLOR}#{topl}#{hor}#{hor}#{Ansi::RESET} #{
            TITLE_ATTR
          }#{title}#{Ansi::RESET} #{COLOR}#{hor * rcount}#{topr}#{Ansi::RESET}"
        )
        @bottom = "#{COLOR}#{botl}#{hor * (width - 2)}#{botr}#{Ansi::RESET}"
        vert = "#{COLOR}#{vert}#{Ansi::RESET}"
        super(
          parent,
          prefix: "#{vert} ",
          suffix:
            "#{Ansi::CURSOR_RIGHT_ALIGNED}#{
              Ansi.cursor_left(suffix_width + 1)
            } #{vert}",
          **opts
        )
      end

      def suffix = "#{super} "
      def finish = parent.puts(@bottom)

      def components(type)
        COMPONENTS[type] || raise(ArgumentError, "invalid frame type - #{type}")
      end

      COLOR = Ansi[39].freeze
      TITLE_ATTR = Ansi[:bold, 231].freeze
      COMPONENTS = {
        rounded: %w[╭ ╮ ╰ ╯ ─ │],
        simple: %w[┌ ┐ └ ┘ ─ │],
        heavy: %w[┏ ┓ ┗ ┛ ━ ┃],
        semi: %w[┍ ┑ ┕ ┙ ━ │],
        double: %w[╔ ╗ ╚ ╝ ═ ║]
      }.compare_by_identity.freeze
    end
    private_constant :Framed

    class Ask < Ask
      protected def finish = out!(Ansi::LINE_CLEAR)
    end
    private_constant :Ask

    class Request < Request
      protected def finish = out!(FINISH)
      FINISH = (Ansi::CURSOR_LINE_UP + Ansi::LINE_ERASE_TO_END).freeze
    end
    private_constant :Request

    class Task < Message
      include ProgressAttributes
      include TaskMethods
    end
    private_constant :Task

    class Progress < Progress
      protected

      def draw(title)
        @prefix = "#{prefix}#{TITLE_PREFIX}#{title}#{Ansi::RESET} "
        (wrapper.stream << @prefix << Ansi::CURSOR_HIDE).flush
        @prefix = "#{Ansi::LINE_CLEAR}#{@prefix}"
        return @prefix << BAR_COLOR if @max_value
        @prefix << INDICATOR_ATTRIBUTE
        @indicator = 0
      end

      def redraw
        (wrapper.stream << @prefix << (@max_value ? fullbar : indicator)).flush
      end

      def end_draw = (wrapper.stream << ERASE).flush
      def indicator = '◐◓◑◒'[(@indicator += 1) % 4]

      def fullbar
        percent = @value / @max_value
        count = (30 * percent).to_i
        mv = max_value.to_i.to_s
        "#{'█' * count}#{BAR_BACK}#{'▁' * (30 - count)}" \
          "#{BAR_INK} #{value.to_i.to_s.rjust(mv.size)}/#{mv} " \
          "(#{(percent * 100).round(2).to_s.rjust(6)})"
      end

      TITLE_PREFIX = "#{Ansi[:bold, :italic, 117]}➔#{Ansi[:reset, 117]} ".freeze
      INDICATOR_ATTRIBUTE = Ansi[:bold, 220].freeze
      BAR_COLOR = Ansi[39, 295].freeze
      BAR_BACK = Ansi[236, 492].freeze
      BAR_INK = Ansi[:bold, 255, :on_default].freeze
      ERASE = (Ansi::LINE_CLEAR + Ansi::CURSOR_SHOW).freeze
    end
    private_constant :Progress
  end

  private_constant :AnsiWrapper
end
