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
        line = plain(line)
        if (@num += 1).odd?
          line.each_char do |char|
            cursor(char)
            (@stream << char).flush
          end
        else
          pos = @column + line.size
          line.reverse!
          line.each_char do |char|
            @stream << Ansi.cursor_column(pos -= 1)
            cursor(char)
            (@stream << char).flush
          end
        end
      end

      def cursor(char)
        return sleep(0.016) if SPACE.match?(char)
        @stream << @cursor_color
        '▁▂▃▄▅▆▇█'.each_char do |cursor|
          (@stream << cursor).flush
          sleep(0.002)
          @stream << CURSOR_BACK
        end
        @stream << @color
      end

      def print_org(line)
        plain(line).each_char do |char|
          if SPACE.match?(char)
            sleep(0.016)
          else
            @stream << @cursor_color
            '▁▂▃▄▅▆▇█'.each_char do |cursor|
              (@stream << cursor).flush
              sleep(0.002)
              @stream << CURSOR_BACK
            end
          end
          (@stream << @color << char).flush
        end
      end

      CURSOR_BACK = Ansi.cursor_back(1)
    end

    define type_writer: TypeWriter
  end
end
