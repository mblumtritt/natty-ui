# frozen_string_literal: true

require 'io/console'
require_relative 'wrapper'
require_relative 'ansi'

module NattyUI
  class AnsiWrapper < Wrapper
    def ansi? = true

    def page
      unless block_given?
        @stream.flush
        return self
      end
      (@stream << PAGE_BEGIN).flush
      begin
        yield(self)
      ensure
        (@stream << PAGE_END).flush
      end
    end

    def temporary
      unless block_given?
        @stream.flush
        return self
      end
      count = @lines_written
      begin
        yield(self)
      ensure
        count = @lines_written - count
        if count.nonzero?
          @stream << Ansi.cursor_line_up(count) << Ansi.screen_erase_below
        end
        @stream.flush
      end
    end

    protected

    def embellish(obj)
      return if obj.nil? || obj.empty?
      reset = false
      ret =
        obj
          .to_s
          .gsub(RE_EMBED) do
            match = Regexp.last_match[2]
            match.delete_prefix!('/') or next reset = Ansi[*match.split]
            match.empty? or next "{{:#{match}:}}"
            reset = false
            Ansi.reset
          end
      reset ? "#{ret}#{Ansi.reset}" : ret
    end

    class Message < Message
      protected

      def title_attr(symbol)
        color = COLORS[symbol]
        if color
          {
            prefix:
              "#{Ansi[:bold, :italic, color]}#{
                symbol
              }#{Ansi[:reset, :bold, color]} ",
            suffix: Ansi.reset
          }
        else
          { prefix: "#{Ansi[:bold, 231]}#{symbol} ", suffix: Ansi.reset }
        end
      end

      COLORS = {
        '•' => 231,
        'i' => 117,
        '!' => 220,
        'X' => 196,
        '✓' => 46,
        'F' => 198,
        '▶︎' => 220,
        '➔' => 117
      }.freeze
    end

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
            stream << Ansi.cursor_line_up(count) << Ansi.screen_erase_below
          end
          stream.flush
        end
      end

      protected

      def initialize(parent, prefix_attr: nil, **opts)
        super
        return unless @prefix && prefix_attr
        @prefix = Ansi.embellish(@prefix, *prefix_attr)
      end
    end

    class Heading < Heading
      protected

      def enclose(weight)
        prefix, suffix = super
        ["#{PREFIX}#{prefix}#{MSG}", "#{PREFIX}#{suffix}#{Ansi.reset}"]
      end

      PREFIX = Ansi[39].freeze
      MSG = Ansi[:bold, 231].freeze
    end

    class Framed < Framed
      protected

      def components(type)
        top_start, top_suffix, left, bottom = super
        [
          "#{Ansi[39]}#{top_start}#{Ansi[:bold, 231]}",
          "#{Ansi[:reset, 39]}#{top_suffix}#{Ansi.reset}",
          Ansi.embellish(left, 39),
          Ansi.embellish(bottom, 39)
        ]
      end
    end

    class Task < Message
      include ProgressAttributes

      protected

      def initialize(parent, title:, **opts)
        @parent = parent
        @count = wrapper.lines_written
        @final_text = [title]
        super(parent, title: title, symbol: '➔', **opts)
      end

      def finish
        return @parent.failed(*@final_text) if failed?
        @status = :ok if @status == :closed
        count = @wrapper.lines_written - @count
        if count.positive?
          (
            wrapper.stream << Ansi.cursor_line_up(count) <<
              Ansi.screen_erase_below
          ).flush
        end
        @parent.completed(*@final_text)
      end
    end

    class Ask < Ask
      protected

      def query(question)
        (wrapper.stream << "#{prefix}#{PREFIX} #{question}#{Ansi.reset} ").flush
      end

      def finish = (wrapper.stream << Ansi.line_clear).flush

      PREFIX = "#{Ansi[:bold, :italic, 220]}▶︎#{Ansi[:reset, 220]}".freeze
    end

    class Query < Query
      protected

      def read(choices, result_typye)
        wrapper.stream << "#{prefix}#{PROMPT} "
        super
      end

      PROMPT = Ansi.embellish(':', :bold, 220).freeze
    end

    class Progress < Progress
      protected

      def draw_title(title)
        @prefix = "#{prefix}#{TITLE_PREFIX}#{title}#{Ansi.reset} "
        (wrapper.stream << @prefix).flush
        @prefix = "#{Ansi.line_clear}#{@prefix}"
        if @max_value
          @prefix << BAR_COLOR
        else
          @prefix << INDICATOR_ATTRIBUTE
          @indicator = 0
        end
      end

      TITLE_PREFIX = "#{Ansi[:bold, :italic, 117]}➔#{Ansi[:reset, 117]} ".freeze
      INDICATOR_ATTRIBUTE = Ansi[:bold, 220].freeze
      BAR_COLOR = Ansi[39, 295].freeze
      BAR_BACK = Ansi[236, 492].freeze
      BAR_INK = Ansi[:bold, 255, :on_default].freeze

      def draw_final = (wrapper.stream << Ansi.line_clear).flush

      def redraw
        (wrapper.stream << @prefix << (@max_value ? fullbar : indicator)).flush
      end

      def indicator = '─╲│╱'[(@indicator += 1) % 4]

      def fullbar
        percent = @value / @max_value
        count = (30 * percent).to_i
        "#{'█' * count}#{BAR_BACK}#{'▁' * (30 - count)}" \
          "#{BAR_INK} #{
            format(
              '%<value>.0f/%<max_value>.0f (%<percent>.2f%%)',
              value: @value,
              max_value: @max_value,
              percent: percent * 100
            )
          }"
      end
    end

    PAGE_BEGIN =
      "#{Ansi.reset}#{Ansi.cursor_save_pos}#{Ansi.screen_save}" \
        "#{Ansi.cursor_home}#{Ansi.screen_erase}".freeze
    PAGE_END =
      "#{Ansi.screen_restore}#{Ansi.cursor_restore_pos}#{Ansi.reset}".freeze
  end

  private_constant :AnsiWrapper
end
