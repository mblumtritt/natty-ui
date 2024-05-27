# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    #
    # Print items of a given list as columns.
    # In the default compact format columns may have diffrent widths and the
    # list items are ordered column-wise.
    # The non-compact format prints all columns in same width and order the list
    # items row-wise.
    #
    # @example simple compact list
    #   ui.ls('apple', 'banana', 'blueberry', 'pineapple', 'strawberry')
    #   # => apple   banana   blueberry   pineapple   strawberry
    #
    # @example (unordered) list with red dot
    #   ui.ls('apple', 'banana', 'blueberry', 'pineapple', 'strawberry', glyph: '[[red]]•[[/]]')
    #   # => • apple   • banana   • blueberry   • pineapple   • strawberry
    #
    # @example ordered list
    #   ui.ls('apple', 'banana', 'blueberry', 'pineapple', 'strawberry', glyph: 1)
    #   # => 1 apple   2 banana   3 blueberry   4 pineapple   5 strawberry
    #
    # @example ordered list, start at 100
    #   ui.ls('apple', 'banana', 'blueberry', 'pineapple', 'strawberry', glyph: 100)
    #   # => 1 apple   2 banana   3 blueberry   4 pineapple   5 strawberry
    #
    # @example ordered list using, uppercase characters
    #   ui.ls('apple', 'banana', 'blueberry', 'pineapple', 'strawberry', glyph: :A)
    #   # => A apple   B banana   C blueberry   D pineapple   E strawberry
    #
    # @example ordered list, using lowercase characters
    #   ui.ls('apple', 'banana', 'blueberry', 'pineapple', 'strawberry', glyph: :a)
    #   # => a apple   b banana   c blueberry   d pineapple   e strawberry
    #
    # @param [Array<#to_s>] args items to print
    # @param [Boolean] compact whether to use compact format
    # @param [nil,#to_s,Integer,Symbol] glyph optional glyph used as element
    #   prefix
    # @return [Wrapper, Wrapper::Element] itself
    def ls(*args, compact: true, glyph: nil)
      _element(:ListInColumns, args, compact, glyph)
    end
  end

  class Wrapper
    #
    # An {Element} to print items of a given list as columns.
    #
    # @see Features#ls
    class ListInColumns < Element
      protected

      def call(list, compact, glyph)
        return @parent if list.empty?
        list.flatten!
        cvt = cvt(glyph, list.size)
        list.map! do |item|
          Item.new(item = cvt[item], NattyUI.display_width(item))
        end
        if compact
          each_compacted(list, available_width - 1) { @parent.puts(_1) }
        else
          each(list, available_width - 1) { @parent.puts(_1) }
        end
        @parent
      end

      def cvt(glyph, size)
        enum =
          case glyph
          when nil, false
            return ->(s) { s.to_s }
          when :hex
            glyph = 1
            pad = size.to_s(16).size
            Enumerator.produce(glyph) { (glyph += 1).to_s(16).rjust(pad, '0') }
          when Integer
            pad = (glyph + size).to_s.size
            Enumerator.produce(glyph) { (glyph += 1).to_s.rjust(pad) }
          when Symbol
            Enumerator.produce(glyph, &:succ)
          else
            return ->(s) { "#{glyph} #{s}" }
          end
        ->(s) { "#{enum.next} #{s}" }
      end

      def each(list, max_width)
        width = list.max_by(&:width).width + 3
        list.each_slice(max_width / width) do |slice|
          yield(slice.map { _1.to_s(width) }.join)
        end
      end

      def each_compacted(list, max_width)
        found, widths = find_columns(list, max_width)
        fill(found[-1], found[0].size)
        found.transpose.each do |row|
          row = row.each_with_index.map { |item, col| item&.to_s(widths[col]) }
          yield(row.join)
        end
      end

      def find_columns(list, max_width)
        found = [list]
        widths = [list.max_by(&:width).width]
        1.upto(list.size - 1) do |slice_size|
          candidate = list.each_slice(list.size / slice_size).to_a
          cwidths = candidate.map { _1.max_by(&:width).width + 3 }
          cwidths[-1] -= 3
          break if cwidths.sum > max_width
          found = candidate
          widths = cwidths
        end
        [found, widths]
      end

      def fill(ary, size)
        diff = size - ary.size
        ary.fill(nil, ary.size, diff) if diff.positive?
      end

      Item =
        Struct.new(:str, :width) do
          def to_s(in_width) = "#{str}#{' ' * (in_width - width)}"
        end

      private_constant :Item
    end
  end
end
