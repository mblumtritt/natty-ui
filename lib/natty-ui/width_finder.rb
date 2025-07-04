# frozen_string_literal: true

module NattyUI
  class WidthFinder
    # sum, columns =
    def self.find(columns, max_width, saving_by_column = 1)
      new(columns, max_width, saving_by_column).find
    end

    # width, padding_left, padding_right =
    def self.adjust(width, padding_left, padding_right)
      target = (width / 2) + 1
      padding = padding_left + padding_right
      return width - padding, padding_left, padding_right if padding < target
      ep = ([padding_left, padding_right].max * 100.0) / padding
      padding = width - target
      [
        target,
        padding_left = ((padding * ep) / 100).to_i,
        padding - padding_left
      ]
    end

    def initialize(columns, max_width, saving_by_column)
      @max_width = max_width
      @saving_by_column = saving_by_column
      columns, max = fit_max_width(columns, max_width, saving_by_column)
      default = max_width / columns.size
      @columns = columns.map { Column.create(_1, default, max) }
    end

    def find
      sum = @columns.sum(&:value)
      if sum < @max_width
        sum = expand(sum)
      elsif @max_width < sum
        sum = shrink(sum)
      end
      [sum, @columns.map(&:value)]
    end

    private

    def fit_max_width(columns, max_width, saving_by_column)
      ret = max_width - columns.size + 1
      return columns, ret if ret >= 1
      saving_by_column += 1
      columns = columns.dup
      until ret >= 1
        columns.pop
        ret += saving_by_column
      end
      [columns, ret]
    end

    def expand(sum)
      max_width = [@columns.sum(&:max_val), @max_width].min
      expandables = @columns.find_all(&:expandable?)
      while !expandables.empty? && sum < max_width
        curr = expandables.min_by(&:value)
        curr.value += 1
        sum += 1
        expandables.delete(curr) unless curr.expandable?
      end
      sum
    end

    def shrink(sum)
      sum = shrink_elastic(sum)
      return sum if sum <= @max_width
      sum = shrink_harder(sum, @columns.find_all { _1.value > 1 && _1.fix? })
      return sum if sum <= @max_width
      sum = shrink_harder(sum, @columns.find_all { _1.value > 1 })
      until sum <= @max_width
        sum -= @columns.pop.value
        sum -= @saving_by_column
      end
      sum
    end

    def shrink_elastic(sum)
      shrinkables = @columns.find_all(&:shrinkable?)
      while !shrinkables.empty? && @max_width < sum
        curr = shrinkables.max_by(&:min_dist)
        curr.value -= 1
        sum -= 1
        shrinkables.delete(curr) unless curr.shrinkable?
      end
      sum
    end

    def shrink_harder(sum, shrinkables)
      while !shrinkables.empty? && @max_width < sum
        curr = shrinkables.max_by(&:value)
        curr.value -= 1
        sum -= 1
        shrinkables.delete(curr) if curr.value == 1
      end
      sum
    end

    Column =
      Struct.new(:value, :min_val, :max_val) do
        def self.create(value, default, max)
          case value
          when nil
            new(default, 1, max)
          when Range
            min = (value.begin || 1).clamp(1, max)
            max = (value.end || max).clamp(1, max)
            new(min + ((max - min) / 2), min, max)
          else
            new(value = value.clamp(1, max), value, value)
          end
        end

        def shrinkable? = min_val < value
        def expandable? = value < max_val
        def fix? = min_val == max_val
        def min_dist = value - min_val
      end
    private_constant :Column
  end
  private_constant :WidthFinder
end
