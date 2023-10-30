# frozen_string_literal: true

require 'io/console'
require_relative 'wrapper'
require_relative 'ansi'

module NattyUI
  class AnsiWrapper < Wrapper
    class Progression < Wrapper::Progression
      protected

      PREFIX = "#{Ansi[39]}➔".freeze
      BAR_COLOR = Ansi[39, 295].freeze
      BAR_BACK = Ansi[236, 492].freeze
      BAR_INK = Ansi[:bold, 255, :on_default].freeze
      CHARS = '─╲│╱'

      private_constant :PREFIX, :BAR_COLOR, :BAR_BACK, :BAR_INK, :CHARS

      def draw(clear)
        @wrapper.stream << "#{Ansi.line_clear if clear}#{PREFIX} #{@message} "
        return draw_bar if @max_value
        unless @value.zero?
          @wrapper.stream << BAR_INK << CHARS[@value.to_i % CHARS.size]
        end
      ensure
        (@wrapper.stream << Ansi.reset).flush
      end

      def draw_bar
        pc = @value / @max_value
        cn = (30 * pc).to_i
        @wrapper.stream << "#{BAR_COLOR}#{'█' * cn}" \
          "#{BAR_BACK}#{'•' * (30 - cn)}#{BAR_INK} " \
          "#{format('%.0f/%.0f (%.2f%%)', @value, @max_value, pc * 100)}"
      end

      def clear_on_end = (@wrapper.stream << Ansi.line_clear)
    end

    private_constant :Progression

    def ansi? = true
    def screen_size = @stream.winsize
    def screen_rows = @stream.winsize[0]
    def screen_columns = @stream.winsize[-1]

    def with(*attributes)
      return to_proc(__method__, *attributes) unless block_given?
      @stream << (attributes = Ansi[*attributes])
      yield(self)
    ensure
      @stream << Ansi.reset unless attributes.empty?
      @stream.flush
    end

    def page
      return flush unless block_given?
      (@stream << PAGE_BEGIN).flush
      begin
        yield(self)
      ensure
        (@stream << PAGE_END).flush
      end
    end

    protected

    def create_progression(message, max_value)
      Progression.new(self, message, max_value)
    end

    def _section(symbol, msg, *args)
      @stream << "#{Ansi[:bold, :italic, COLORS[symbol]]}#{symbol}" \
        "#{Ansi[:bold_off, :italic_off]} #{msg}#{Ansi.reset}\n"
      each_line(*args) { |s| @stream << '  ' << s << "\n" } unless args.empty?
      flush
    end

    def begin_query(question, choices)
      @stream << "#{QUERY_PREFIX} #{question}#{Ansi.reset}\n"
      choices.each_pair do |key, msg|
        @stream << "  #{QUERY_KEY}#{key}#{QUERY_MSG} #{msg}#{Ansi.reset}\n"
      end
      @stream << QUERY_SUFFIX
      @stream.flush
      choices.size + 1
    end

    def end_query(lines)
      @stream << Ansi.cursor_line_up(lines) << Ansi.screen_erase_below
      @stream.flush
    end

    def begin_asking(question)
      (@stream << "#{QUERY_PREFIX} #{question} #{Ansi.reset}").flush
      true
    end

    def end_asking(_) = (@stream << Ansi.line_clear).flush

    COLORS = { '•' => 231, 'i' => 39, '!' => 220, 'X' => 196, '✓' => 46 }.freeze

    PAGE_BEGIN =
      "#{Ansi.reset}#{Ansi.cursor_save_pos}#{Ansi.screen_save}" \
        "#{Ansi.cursor_home}#{Ansi.screen_erase}".freeze
    PAGE_END =
      "#{Ansi.screen_restore}#{Ansi.cursor_restore_pos}#{Ansi.reset}".freeze

    QUERY_PREFIX =
      "#{Ansi[:bold, :italic, 220]}▶︎#{Ansi[:bold_off, :italic_off]}".freeze
    QUERY_SUFFIX = "#{Ansi[:bold, 220]}▶︎#{Ansi.reset}".freeze
    QUERY_KEY = Ansi[:bold, :underline, 231].freeze
    QUERY_MSG = Ansi[:reset, 255].freeze
  end

  private_constant :AnsiWrapper
end
