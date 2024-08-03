# frozen_string_literal: true

module NattyUI
  module Animation
    class Matrix < Base
      protected

      def write(stream)
        plains = @lines.map { |line, _| Text.plain(line) }
        encs = @lines.map { Array.new(_2) { CHARS.sample }.join }
        poss = @lines.map { Array.new(_2, &:itself).shuffle }
        stream << attribute(:style, :default)
        until poss.all?(&:empty?)
          poss.each_with_index do |pos, idx|
            next stream << Ansi::LINE_NEXT if pos.empty?
            line = plains[idx]
            if (count = (pos.size / 11.0).round) < 2
              encs[idx] = enc = line
              pos.clear
            else
              enc = encs[idx]
              pos.pop(count).each { enc[_1] = line[_1] }
              pos.sample(pos.size / 3).each { enc[_1] = CHARS.sample }
            end
            puts(stream, enc)
          end
          (stream << @top).flush
          sleep(0.1)
        end
        super
      end

      def print2(line)
        line = Text.plain(line)
        str = Array.new(line.size) { CHARS.sample }.join
        pos = Array.new(line.size, &:itself).shuffle
        until pos.size < 4
          pos.shift(pos.size / 4).each { str[_1] = line[_1] }
          pos.sample(pos.size / 2).each { str[_1] = CHARS.sample }
          (@stream << "#{@prefix}#{str}").flush
          sleep(0.08)
        end
      end

      CHARS = '2598Z*):.\=+-¦|_ｦｱｳｴｵｶｷｹｺｻｼｽｾｿﾀﾂﾃﾅﾆﾇﾈﾊﾋﾎﾏﾐﾑﾒﾓﾔﾕﾗﾘﾜ'.chars.freeze
    end

    define matrix: Matrix
    private_constant :Matrix
  end
end
