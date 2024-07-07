# frozen_string_literal: true

module NattyUI
  module LineAnimation
    class Test < None
      def initialize(*_)
        super
        @color = attribute(:color, :default)
      end

      def print(line, column)
        prefix = "#{Ansi.cursor_column(column)}#{@color}"
        line = plain(line)
        str = Array.new(line.size) { CHARS.sample }.join
        pos = Array.new(line.size, &:itself).shuffle
        until pos.size < 4
          pos.shift(pos.size / 4).each { str[_1] = line[_1] }
          pos.sample(pos.size / 2).each { str[_1] = CHARS.sample }
          (@stream << "#{prefix}#{str}").flush
          sleep(0.08)
        end
      end

      CHARS = '2598Z*):.\=+-¦|_ｦｱｳｴｵｶｷｹｺｻｼｽｾｿﾀﾂﾃﾅﾆﾇﾈﾊﾋﾎﾏﾐﾑﾒﾓﾔﾕﾗﾘﾜ'.chars
    end

    define test: Test
  end
end
