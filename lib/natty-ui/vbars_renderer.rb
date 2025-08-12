# frozen_string_literal: true

module NattyUI
  module VBarsRenderer
    class << self
      def lines(vals, width, height, normalize, bar_width, style)
        if style
          bos = Ansi[*style]
          eos = Ansi::RESET
        end
        if ((bar_width != :auto) && bar_width <= 1) || (vals.size * 2 > width)
          db = '▉'
          ds = ' '
          el = "#{bos}#{'▔' * vals.size}#{eos}"
          vals = vals.take(width) if vals.size > width
        else
          bw = (width - vals.size) / vals.size
          bw = [bw, bar_width].min if bar_width != :auto
          db = "#{'█' * bw} "
          bw += 1
          ds = ' ' * bw
          el = "#{bos}#{'▔' * ((bw * vals.size) - 1)}#{eos}"
        end
        height -= 1
        vals = normalize ? normalize!(vals, height) : adjust!(vals, height)
        height
          .downto(1)
          .map { |i| "#{bos}#{vals.map { _1 < i ? ds : db }.join}#{eos}" } << el
      end

      private

      def adjust!(vals, height)
        max = vals.max.to_f
        vals.map { ((_1 / max) * height).round }
      end

      def normalize!(vals, height)
        min, max = vals.minmax
        return Array.new(vals.size, height) if min == max
        max = (max - min).to_f
        vals.map { (((_1 - min) / max) * height).round }
      end
    end
  end

  private_constant :VBarsRenderer
end
