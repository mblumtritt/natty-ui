# frozen_string_literal: true

require_relative 'attributes'
require_relative 'table_renderer'

module NattyUI
  # @todo This chapter needs more documentation.
  #
  # Collection of rows and columns used by {Features.table}.
  #
  class Table
    class Column < NattyUI::Attributes::Base
      include NattyUI::Attributes::Width

      # @return [Integer] column index
      attr_reader :index

      def width
        @width ||= find_width
      end

      def to_s = "#{super.chop} @index:#{@index} @width:#{width.inspect}>"
      alias inspect to_s

      private

      def find_width
        min = max = nil
        @parent.each_cell_of(@index) do |cell|
          next unless cell
          m = cell.attributes.min_width
          min = m if m && (min.nil? || m < min)
          m = cell.attributes.max_width
          max = m if m && (max.nil? || max < m)
        end
        wh_from(min.to_i, max.to_i)
      end

      def respond_to_missing?(name, _)
        return suoer unless name.end_with?('=')
        Cell::Attributes.public_method_defined?(name) || super
      end

      def method_missing(name, *args, **kwargs)
        return super unless name.end_with?('=')
        return super unless Cell::Attributes.public_method_defined?(name)
        @parent.each_cell_of(@index) { _1.attributes.__send__(name, *args) }
        args[0]
      end

      def initialize(parent, index, **attributes)
        super(**attributes)
        @parent = parent
        @index = index
      end
    end

    class ColumnsCollection
      include Enumerable

      # @return [Integer] count of columns
      def count = columns.size

      def empty? = columns.empty?

      # @return [Column, nil] column at given index
      def [](index) = columns[index]

      def each(&block) = columns.each(&block)

      def to_s = "#{super.chop} @columns:#{columns.inspect}>"
      alias inspect to_s

      private

      def columns
        cc = @parent.column_count
        case cc <=> @columns.size
        when -1
          @columns = @columns.take(cc)
        when 1
          bi = @columns.size
          @columns +=
            Array.new(cc - @columns.size) { Column.new(@parent, bi + _1) }
        else
          @columns
        end
      end

      def initialize(parent)
        @parent = parent
        @columns = []
      end

      def initialize_copy(*_)
        super
        @columns = []
      end
    end

    class Row
      include Enumerable

      def empty? = @cells.empty?

      # @return [Integer] count of cells
      def count = @cells.size

      def each(&block) = @cells.each(&block)

      # @return [Cell, nil] cell at given index
      def [](index) = @cells[index]

      # @return [Cell] created cell
      def []=(index, *args)
        @cells[index] = create_cell(args)
        @cells.map! { _1 || Cell.new }
      end

      # Add a new cell to the row with given `text` and `attributes`.
      # @return [Cell] created cell
      def add(*text, **attributes)
        nc = Cell.new(*text, **attributes)
        @cells << nc
        block_given? ? yield(nc) : nc
      end

      def delete(cell)
        cell.is_a?(Cell) ? @cells.delete(cell) : @cells.delete_at(cell)
        self
      end

      # Add a new cell to the row with given `text`.
      # @return [Row] itself
      def <<(text)
        add(text)
        self
      end

      private

      def respond_to_missing?(name, _)
        return super unless name.end_with?('=')
        Cell::Attributes.public_method_defined?(name) || super
      end

      def method_missing(name, *args, **_)
        return super unless name.end_with?('=')
        return super unless Cell::Attributes.public_method_defined?(name)
        @cells.each { _1.attributes.__send__(name, *args) }
        args[0]
      end

      def initialize
        @cells = []
      end

      def initialize_copy(*_)
        super
        @cells = @cells.map(&:dup)
      end

      def create_cell(args)
        args.flatten!(1)
        Cell.new(*args)
      end
    end

    class Cell
      include TextWithAttributes

      class Attributes < NattyUI::Attributes::Base
        prepend NattyUI::Attributes::Width
        prepend NattyUI::Attributes::Padding
        prepend NattyUI::Attributes::Align
        prepend NattyUI::Attributes::Vertical
        prepend NattyUI::Attributes::Style
      end
    end

    class Attributes < NattyUI::Attributes::Base
      prepend NattyUI::Attributes::Border
      prepend NattyUI::Attributes::BorderStyle
      prepend NattyUI::Attributes::BorderAround
    end

    include Enumerable
    include WithAttributes

    # @return [ColumnsCollection] table columns
    attr_reader :columns

    def empty? = @rows.empty?

    # @return [Integer] count of rows
    def count = @rows.size

    # @return [Integer] count of columns
    def column_count = @rows.empty? ? 0 : @rows.max_by(&:count).count

    def each(&block) = @rows.each(&block)

    def [](row_index, column_index = nil)
      row = @rows[row_index] or return
      column_index ? row[column_index] : row
    end

    # @return [Row] created row
    def add(*text, **attributes)
      nr = Row.new
      @rows << nr
      text.each { nr.add(_1, **attributes) }
      block_given? ? yield(nr) : nr
    end

    def delete(row)
      row.is_a?(Row) ? @rows.delete(row) : @rows.delete_at(row)
    end

    def each_cell_of(column_index)
      return to_enum(__method__, column_index) unless block_given?
      return if (column_index = column_index.to_i) >= column_count
      @rows.each { yield(_1[column_index]) }
      nil
    end

    private

    def initialize(**attributes)
      super
      @rows = []
      @columns = ColumnsCollection.new(self)
    end

    def initialize_copy(*_)
      super
      @columns = ColumnsCollection.new(self)
      @rows = @rows.map(&:dup)
    end
  end
end
