# frozen_string_literal: true

module NattyUI
  module Animation
    class Default < Base
      protected

      def write(stream)
        num = 0
        style = attribute(:style, :default)
        @lines.each do |line, size|
          time = 0.25 / size
          stream << style
          line = Text.plain(line)
          if (num += 1).odd?
            stream << @pos1
            line.each_char do |char|
              (stream << char).flush
              sleep(time)
            end
          else
            stream << Ansi.cursor_column(@prefix_width + size - 1)
            line.reverse.each_char do |char|
              (stream << char << CURSOR_LEFT).flush
              sleep(time)
            end
          end
          stream << Ansi::RESET << @pos1 << line << Ansi::LINE_NEXT
        end
      end

      CURSOR_LEFT = Ansi.cursor_back(2).freeze
    end

    define default: Default
    private_constant :Default
  end
end
