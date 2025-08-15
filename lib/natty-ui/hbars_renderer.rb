# frozen_string_literal: true

require_relative 'utils'

module NattyUI
  module HBarsRenderer
    class << self
      def lines(vals, width, normalize, style, text_style)
        if text_style
          bots = Ansi[*text_style]
          eots = Ansi::RESET
        end
        texts = vals.map { Str.new(_1) }
        tw = texts.max_by(&:width).width
        size = width - tw - 1
        if size < 2 # text only
          return texts.map { "#{bots}#{' ' * (tw - _1.width)}#{_1}#{eots}" }
        end
        if style
          bos = Ansi[*style]
          eos = Ansi::RESET
        end
        vals = normalize ? normalize!(vals, size) : adjust!(vals, size)
        texts.map.with_index do |str, idx|
          "#{bots}#{' ' * (tw - str.width)}#{str}#{eots}#{bos}▕#{
            '▆' * vals[idx]
          }#{eos}"
        end
      end

      def lines_bars_only(vals, width, normalize, style)
        if style
          bos = Ansi[*style]
          eos = Ansi::RESET
        end
        width -= 1
        vals = normalize ? normalize!(vals, width) : adjust!(vals, width)
        vals.map { "#{bos}▕#{'▆' * _1}#{eos}" }
      end

      private

      def adjust!(vals, size)
        max = vals.max.to_f
        vals.map { ((_1 / max) * size).round }
      end

      def normalize!(vals, size)
        min, max = vals.minmax
        return Array.new(vals.size, size) if min == max
        max = (max - min).to_f
        vals.map { (((_1 - min) / max) * size).round }
      end
    end
  end

  private_constant :HBarsRenderer
end
