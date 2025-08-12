# frozen_string_literal: true

module NattyUI
  class VBarsRenderer
    def self.[](values, max_size, height, normalize, bar_width, style)
      new(
        values,
        max_size,
        height,
        normalize,
        bar_width,
        Terminal.ansi? ? style : nil
      ).lines.join("\n")
    end

    def initialize(values, max_size, height, normalize, bar_width, style)
      @size = height - 1
      if style
        @bos = Ansi[*style]
        @eos = Ansi::RESET
      end
      if values.size > max_size
        init_min(values.take(max_size))
      elsif (bar_width == :min) || (values.size * 2 > max_size)
        init_min(values)
      else
        @values = values
        bw = (max_size - values.size) / values.size
        bw = [bw, bar_width].min if bar_width != :auto
        @db = "#{'█' * bw} "
        bw += 1
        @ds = ' ' * bw
        @el = '▔' * ((bw * values.size) - 1)
      end
      @values = normalize ? normalize! : adjust!
    end

    def lines
      @size
        .downto(1)
        .map do |i|
          "#{@bos}#{@values.map { |val| val >= i ? @db : @ds }.join}#{@eos}"
        end << "#{@bos}#{@el}#{@eos}"
    end

    private

    def init_min(values)
      @values = values
      @db = '▉'
      @ds = ' '
      @el = '▔' * values.size
    end

    def adjust!
      max = @values.max.to_f
      @values.map { ((_1 / max) * @size).round }
    end

    def normalize!
      min, max = @values.minmax
      return Array.new(@values.size, @size) if min == max
      max = (max - min).to_f
      @values.map { (((_1 - min) / max) * @size).round }
    end
  end

  private_constant :VBarsRenderer
end
