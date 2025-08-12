# frozen_string_literal: true

require_relative 'utils'

module NattyUI
  class HBarsRenderer
    def self.[](values, max_size, size, normalize, style, text_style)
      style = text_style = nil unless Terminal.ansi?
      new(
        values,
        Utils.as_size(3..max_size, size),
        normalize,
        style,
        text_style
      ).lines
    end

    attr_reader :lines

    def initialize(values, max_size, normalize, style, text_style)
      texts = values.map { Str.new(_1) }
      tw = texts.max_by(&:width).width
      size = max_size - tw - 1
      return if size < 2 # TODO may draw only text
      values = normalize ? normalize!(values, size) : adjust!(values, size)
      if style
        bos = Ansi[*style]
        eos = Ansi::RESET
      end
      if text_style
        bots = Ansi[*text_style]
        eots = Ansi::RESET
      end
      @lines =
        texts.map.with_index do |str, idx|
          "#{bots}#{' ' * (tw - str.width)}#{str}#{eots}#{bos}▕#{
            '▆' * values[idx]
          }#{eos}"
        end
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

  private_constant :HBarsRenderer
end
