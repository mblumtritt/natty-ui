# frozen_string_literal: true

module NattyUI
  module LineAnimation
    class Default < None
      def initialize(*_)
        super
        @column = @options[:prefix_width] + 1
        @color = color
        @num = 0
      end

      def print(line)
        line = Text.plain(line)
        time = 0.5 / line.size
        @stream << @color
        if (@num += 1).odd?
          line.each_char do |char|
            (@stream << char).flush
            sleep(time)
          end
        else
          pos = @column + line.size
          line.reverse!
          line.each_char do |char|
            (@stream << Ansi.cursor_column(pos -= 1) << char).flush
            sleep(time)
          end
        end
      end
    end

    define default: Default
    private_constant :Default
  end
end
