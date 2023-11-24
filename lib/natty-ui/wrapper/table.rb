# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    #
    # @param [Enumerable<#to_s>] enum
    # @param [Symbol] type frame type;
    #   valid types are `:simple`, `:heavy`, `:semi`, `:double`
    # @param [Boolean] header whether to use first line as table header
    # @return [nil]
    def table(enum, type: :simple, header: true)
      _element(:Table, enum, type, header)
      nil
    end
  end

  class Wrapper
    class Table < Element
      protected

      def _call(list, type, header)
        table = TableCreator.new(list).shrink_width!(available_width)
        return if table.empty?
        seperator = seperator(type)
        if header
          table.each_line(seperator) do |line|
            @parent.puts(line)
            next unless header
            header = false
            @parent.puts(row_seperator(type, table.col_widths))
          end
        else
          table.each_line(seperator) { |line| @parent.puts(line) }
        end
      end

      def seperator(type)
        SEPERATORS[type] || raise(ArgumentError, "invalid frame type - #{type}")
      end

      def row_seperator(type, col_widths)
        line, sep = ROW_SEPERATORS[type]
        "#{line}#{col_widths.map { |width| line * width }.join(sep)}#{line}"
      end

      SEPERATORS = {
        rounded: ' │ ',
        simple: ' │ ',
        heavy: ' ┃ ',
        semi: ' │ ',
        double: ' ║ '
      }.compare_by_identity.freeze
      private_constant :SEPERATORS

      ROW_SEPERATORS = {
        rounded: %w[─ ─┼─],
        simple: %w[─ ─┼─],
        heavy: %w[━ ━╋━],
        semi: %w[═ ═╪═],
        double: %w[═ ═╬═]
      }.compare_by_identity.freeze
      private_constant :ROW_SEPERATORS
    end

    class TableCreator
      attr_reader :col_widths

      def initialize(enum)
        unless enum.respond_to?(:map)
          raise(ArgumentError, 'argument does not respond to #map')
        end
        @rows = as_rows(enum)
        @col_widths = @rows.transpose.map! { |cell| cell.max_by(&:width).width }
      end

      def empty? = @rows.empty? || @col_widths.empty?

      def shrink_width!(width, sep_size = 3)
        while @col_widths.sum + ((@col_widths.size - 1) * sep_size) + 2 > width
          @col_widths.pop
        end
        @col_widths[-1] += 1 unless empty?
        self
      end

      def each_line(seperator)
        return to_enum(__method__, seperator) { @rows.size } unless block_given?
        @rows.each do |row|
          col = -1
          yield(
            row
              .take(@col_widths.size)
              .map do |cell|
                cell = cell.to_s(@col_widths[col += 1])
                col.zero? ? " #{cell}" : cell
              end
              .join(seperator)
          )
        end
      end

      private

      def as_rows(list)
        cols = []
        list =
          list.map do |obj|
            obj =
              if obj.is_a?(Enumerable)
                obj.map { |i| Cell.new(i = i.to_s, plain_width(i)) }
              else
                [Cell.new(obj = obj.to_s, plain_width(obj))]
              end
            cols << obj.size
            obj
          end
        size = cols.max or return
        list.each do |row|
          diff = size - row.size
          row.fill(EMPTY_CELL, row.size, diff) if diff.positive?
        end
      end

      def plain_width(str) = NattyUI.display_width(NattyUI.plain(str))

      Cell =
        Data.define(:str, :width) do
          def to_s(in_width) = "#{str}#{' ' * (in_width - width)}"
        end
      EMPTY_CELL = Cell.new('', 0)
    end
    private_constant :TableCreator
  end
end
