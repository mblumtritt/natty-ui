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
      def initialize(parent, prefix_attr: nil, **opts)
        super
        return unless @prefix && prefix_attr
        @prefix = Ansi.embellish(@prefix, *prefix_attr)
      end
    end

    class Task < Message
      include NattyUI::Wrapper::TaskAttributes

      protected

      def cleanup
        count = @wrapper.lines_written - @count
        return if count <= 0
        (
          wrapper.stream << Ansi.cursor_line_up(count) <<
            Ansi.screen_erase_below
        ).flush
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

    class Ask < Ask
      protected

      def query(question)
        (wrapper.stream << "#{prefix}#{PREFIX} #{question} #{Ansi.reset}").flush
      end

      def finish = (wrapper.stream << Ansi.line_clear).flush

      PREFIX = "#{Ansi[:bold, :italic, 220]}▶︎#{Ansi[:reset, 220]}".freeze
    end

    class Query < Query
      protected

      def query(question, choices)
        super
        wrapper.stream << "#{prefix}#{PROMPT} "
      end

      PROMPT = Ansi.embellish(':', :bold, 220).freeze
    end

    PAGE_BEGIN =
      "#{Ansi.reset}#{Ansi.cursor_save_pos}#{Ansi.screen_save}" \
        "#{Ansi.cursor_home}#{Ansi.screen_erase}".freeze
    PAGE_END =
      "#{Ansi.screen_restore}#{Ansi.cursor_restore_pos}#{Ansi.reset}".freeze
  end

  private_constant :AnsiWrapper
end
