# frozen_string_literal: true

module NattyUI
  module Animation
    class TypeWriter < Base
      protected

      def write(stream)
        num = 0
        @style = attribute(:style, :default)
        @cursor_style = attribute(:cursor_style, 0x2e)
        @lines.each do |line, size|
          line = Ansi.plain(line)
          if (num += 1).odd?
            stream << @pos1
            line.each_char { cursor(stream, _1).flush }
          else
            stream << Ansi.cursor_column(@prefix_width + size - 1)
            line.reverse.each_char do |char|
              (cursor(stream, char) << CURSOR_2LEFT).flush
            end
          end
          stream << Ansi::RESET << @pos1 << line << Ansi::LINE_NEXT
        end
      end

      def cursor(stream, char)
        stream << @cursor_style
        (SPACE.match?(char) ? '▁' : '▁▂▃▄▅▆▇█').each_char do |cursor|
          (stream << cursor << CURSOR_1LEFT).flush
          sleep(0.002)
        end
        stream << @style << char
      end

      CURSOR_1LEFT = Ansi.cursor_back(1).freeze
      CURSOR_2LEFT = Ansi.cursor_back(2).freeze
      SPACE = /[[:space:]]/
    end

    define type_writer: TypeWriter
    private_constant :TypeWriter
  end
end
