# frozen_string_literal: true

module NattyUI
  class LSRenderer
    class << self
      def lines(items, glyph, max_width)
        items = as_items(items, glyph)
        lines = []
        width = items.max_by(&:width).width + 3
        return lines if (sl_size = max_width / width).zero?
        items.each_slice(sl_size) do |slice|
          lines << slice.map { _1.to_s(width) }.join
        end
        lines
      end

      private

      def as_items(items, glyph)
        items.flatten!
        glyph = as_glyph(glyph, items.size)
        items.map! { |item| Item.new(item = glyph[item], Text.width(item)) }
      end

      def as_glyph(glyph, size)
        case glyph
        when nil, false
          lambda(&:itself)
        when :hex
          pad = size.to_s(16).size
          glyph = 0
          ->(s) { "#{(glyph += 1).to_s(16).rjust(pad, '0')} #{s}" }
        when Integer
          pad = (glyph + size).to_s.size
          glyph -= 1
          ->(s) { "#{(glyph += 1).to_s.rjust(pad, ' ')} #{s}" }
        when Symbol
          lambda do |s|
            "#{
              t = glyph
              glyph = glyph.succ
              t
            } #{s}[/]"
          end
        else
          ->(s) { "#{glyph} #{s}" }
        end
      end

      Item =
        Struct.new(:str, :width) do
          def to_s(in_width) = "#{str}#{' ' * (in_width - width)}"
        end
      private_constant :Item
    end
  end

  class CompactLSRenderer < LSRenderer
    class << self
      def lines(items, glyph, max_width)
        items = as_items(items, glyph)
        return [] if items.empty?
        found, widths = find_columns(items, max_width)
        fill(found[-1], found[0].size)
        found.transpose.map! do |row|
          row.each_with_index.map { |item, col| item&.to_s(widths[col]) }.join
        end
      end

      private

      def find_columns(items, max_width)
        found = [items]
        widths = [items.max_by(&:width).width]
        1.upto(items.size - 1) do |slice_size|
          candidate = items.each_slice(items.size / slice_size).to_a
          cwidths = candidate.map { _1.max_by(&:width).width + 3 }
          cwidths[-1] -= 3
          break if cwidths.sum > max_width
          found = candidate
          widths = cwidths
        end
        [found, widths]
      end

      def fill(ary, size)
        (diff = size - ary.size).positive? && ary.fill(nil, ary.size, diff)
      end
    end
  end

  private_constant :LSRenderer, :CompactLSRenderer
end
