# frozen_string_literal: true

module NattyUI
  module VBarsRenderer
    class << self
      def lines(values, max_size, height, normalize, bar_width, style)
        size = height - 1
        if style
          bos = Ansi[*style]
          eos = Ansi::RESET
        end
        if (bar_width == :min) || (values.size * 2 > max_size)
          db = '▉'
          ds = ' '
          el = '▔' * values.size
          values = values.take(max_size) if values.size > max_size
        else
          bw = (max_size - values.size) / values.size
          bw = [bw, bar_width].min if bar_width != :auto
          db = "#{'█' * bw} "
          bw += 1
          ds = ' ' * bw
          el = '▔' * ((bw * values.size) - 1)
        end
        values = normalize ? normalize!(values, size) : adjust!(values, size)
        size
          .downto(1)
          .map do |i|
            "#{bos}#{values.map { _1 < i ? ds : db }.join}#{eos}"
          end << "#{bos}#{el}#{eos}"
      end

      private

      def adjust!(values, size)
        max = values.max.to_f
        values.map { ((_1 / max) * size).round }
      end

      def normalize!(values, size)
        min, max = values.minmax
        return Array.new(values.size, size) if min == max
        max = (max - min).to_f
        values.map { (((_1 - min) / max) * size).round }
      end
    end
  end

  private_constant :VBarsRenderer
end
