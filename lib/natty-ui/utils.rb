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
    end

    POS_ALI = %i[right centered].freeze
    VERT = %i[bottom middle].freeze
    TAB_ATTR = %i[border_around border border_style position].freeze
  end

  class Str
    attr_reader :to_s

    alias to_str to_s
    def inspect = @to_s.inspect
    def empty? = size == 0

    def size
      return @size if @size
      @size = Text.width(self)
      freeze
      @size
    end
    alias width size

    def initialize(str, size = nil)
      @to_s = Ansi.bbcode(str).freeze
      return unless size
      @size = @size.is_a?(Integer) ? size : Text.width(self)
      freeze
    end
  end

  private_constant :Utils, :Str
end
