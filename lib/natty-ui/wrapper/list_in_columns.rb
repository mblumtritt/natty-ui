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
    # @param [Array<#to_s>] args items to print
    # @param [Boolean] compact whether to use compact format
    # @return [Wrapper, Wrapper::Element] itself
    def ls(*args, compact: true) = _element(:ListInColumns, args, compact)
  end

  class Wrapper
    #
    # An {Element} to print items of a given list as columns.
    #
    # @see Features#ls
    class ListInColumns < Element
      protected

      def _call(list, compact)
        return parent if list.empty?
        list.flatten!
        list.map! { |item| Item.new(item = item.to_s, _cleared_width(item)) }
        if compact
          each_compacted(list, available_width) { parent.puts(_1) }
        else
          each(list, available_width) { parent.puts(_1) }
        end
        parent
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
          # @!visibility private
          def to_s(in_width) = "#{str}#{' ' * (in_width - width)}"
        end

      private_constant :Item
    end
  end
end
