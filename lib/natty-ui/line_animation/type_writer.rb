# frozen_string_literal: true

module NattyUI
  module LineAnimation
    class TypeWriter < None
      def initialize(*_)
        super
        @color = color
        @cursor_color = attribute(:cursor_color, 0x2e)
        @column = @options[:prefix_width] + 1
        @num = 0
      end

      def print(line)
        line = Text.plain(line)
        if (@num += 1).odd?
          line.each_char { (@stream << cursor(_1)).flush }
        else
          pos = @column + line.size
          line.reverse!
          line.each_char do |char|
            @stream << Ansi.cursor_column(pos -= 1)
            (@stream << cursor(char)).flush
          end
        end
      end

      def cursor(char)
        @stream << @cursor_color
        (SPACE.match?(char) ? '▁' : '▁▂▃▄▅▆▇█').each_char do |cursor|
          (@stream << cursor).flush
          sleep(0.002)
          @stream << CURSOR_BACK
        end
        @stream << @color
        char
      end

      CURSOR_BACK = Ansi.cursor_back(1)
    end

    define type_writer: TypeWriter
  end
end
