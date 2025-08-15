# frozen_string_literal: true

module NattyUI
  module Utils
    class << self
      # @!visibility private
      def style(value)
        value =
          case value
          when Array
            value.dup
          when Enumerable
            value.to_a
          when Symbol, Integer
            [value]
          when nil
            return
          else
            value.to_s.delete_prefix('[').delete_suffix(']').split
          end
        value.uniq!
        value.keep_if { Ansi.valid?(_1) }.empty? ? nil : value
      end

      # @!visibility private
      def align(value)
        POS_ALI.include?(value) ? value : :left
      end

      # @!visibility private
      def position(value)
        value if POS_ALI.include?(value)
      end

      # @!visibility private
      def vertical(value)
        VERT.include?(value) ? value : :top
      end

      # @!visibility private
      def split_table_attr(values)
        [values.slice(*TAB_ATTR), values.except(*TAB_ATTR)]
      end

      # @!visibility private
      def padding(*value)
        value = value.flatten.take(4).map! { [0, _1.to_i].max }
        case value.size
        when 0
          [0, 0, 0, 0]
        when 1
          Array.new(4, value[0])
        when 2
          value * 2
        when 3
          value << value[1]
        else
          value
        end
      end
      alias margin padding

      # @!visibility private
      def as_size(range, value)
        return range.begin if value == :min
        return range.end if value.nil? || value.is_a?(Symbol)
        (
          if value.is_a?(Numeric)
            (value > 0 && value < 1 ? (range.end * value) : value).round
          else
            value.to_i
          end
        ).clamp(range)
      end
    end

    POS_ALI = %i[right centered].freeze
    VERT = %i[bottom middle].freeze
    TAB_ATTR = %i[border_around border border_style position].freeze
  end

  class Str
    attr_reader :to_s
    alias to_str to_s
    def empty? = width == 0
    def inspect = @to_s.inspect

    def width
      return @width if @width
      @width = Text.width(self)
      freeze
      @width
    end

    def +(other)
      other = Str.new(other) unless other.is_a?(Str)
      Str.new(@to_s + other.to_s, width + other.width)
    end

    if Terminal.ansi?
      def initialize(str, width = nil)
        @to_s = Ansi.bbcode(str).freeze
        return unless width
        @width = @width.is_a?(Integer) ? width : Text.width(self)
        freeze
      end
    else
      def initialize(str, width = nil)
        @to_s = Ansi.plain(str).freeze
        return unless width
        @width = @width.is_a?(Integer) ? width : Text.width(self)
        freeze
      end
    end
  end

  private_constant :Utils, :Str
end
