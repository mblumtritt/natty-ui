# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    #
    # Generate a table view.
    #
    # @example Generate a simple table
    #   ui.table(
    #     %w[name price origin],
    #     %w[apple 1$ California],
    #     %w[banana 2$ Brasil],
    #     %w[kiwi 1.5$ Newzeeland]
    #   )
    #   # name   │ price │ origin
    #   # ───────┼───────┼───────────
    #   # apple  │ 1$    │ California
    #   # ───────┼───────┼───────────
    #   # banana │ 2$    │ Brasil
    #   # ───────┼───────┼───────────
    #   # kiwi   │ 1.5$  │ Newzeeland
    #
    # @example Generate a formatted table
    #   ui.table(type: :heavy, expand: true) do |table|
    #     table.add('name', 'price', 'origin', style: 'bold green')
    #     table.add('apple', '1$', 'California')
    #     table.add('banana', '2$', 'Brasil')
    #     table.add('kiwi', '1.5$', 'Newzeeland')
    #     table.align_column(0, :right).align_row(0, :center)
    #   end
    #   #       name       ┃      price     ┃            origin
    #   # ━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    #   #            apple ┃ 1$             ┃ California
    #   # ━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    #   #           banana ┃ 2$             ┃ Brasil
    #   # ━━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━╋━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    #   #             kiwi ┃ 1.5$           ┃ Newzeeland
    #
    # @param [#map<#map<#to_s>>] table one or more arrays representing rows of the table
    # @param [Symbol, String] type frame type; see {NattyUI::Frame}
    # @param [false, true. :equal] expand
    # @yieldparam table [Table] construction helper
    # @return [Wrapper::Section, Wrapper] it's parent object
    def table(*table, type: :default, expand: false)
      type = NattyUI::Frame[type]
      table = Table.create(*table)
      yield(table) if block_given?
      (table = table.to_a).empty? ? self : _element(:Table, table, type, expand)
    end

    #
    # Table-like display of key/value pairs.
    #
    # @example
    #   ui.pairs(apple: '1$', banana: '2$', kiwi: '1.5$')
    #
    #   # output:
    #   #  apple: 1$
    #   # banana: 2$
    #   #   kiwi: 1.5$
    #
    # @param [#to_s] seperator
    # @param [Hash<#to_s,#to_s>] kwargs
    # @return [Wrapper::Section, Wrapper] it's parent object
    def pairs(seperator = ': ', **kwargs)
      kwargs.empty? ? self : _element(:Pairs, kwargs, seperator)
    end

    #
    # Helper class to define a table layout.
    #
    # @see #table
    #
    class Table
      # @!visibility private
      def self.create(*table)
        table = table[0] if table.size == 1 && table[0].respond_to?(:each)
        return table if table.is_a?(self.class)
        ret = new
        table.each { ret.add_row(*_1) }
        ret
      end

      # @!visibility private
      def initialize = @rows = []

      # @return [Integer] count of rows
      def row_count = @rows.size

      # @return [Integer] count of columns
      def col_count = @rows.max_by { _1&.size || 0 }&.size || 0

      # Get the {Cell} at a table position.
      #
      # @param [Integer] row row index
      # @param [Integer] col column index
      # @return [Cell] at row/column
      # @return [nil] if no cell defined at row/column
      def [](row, col) = @rows.dig(row, col)

      # Change {Cell} or (text) value at a table position.
      #
      # @example change {Cell} at row 2, column 3
      #   table[2, 3] = table.cell('Hello World', align: right, style: 'bold')
      #
      # @example change text at row 2, column 3
      #   table[2, 3] = 'Hello Ruby!'
      #
      # @example delete {Cell} at row 2, column 3
      #   table[2, 3] = nil
      #
      # @param [Integer] row row index
      # @param [Integer] col column index
      # @param [Cell, #to_s, nil] value Cell or text to use at specified position
      # @return [Cell, #to_s, nil] the value
      def []=(row, col, value)
        row = (@rows[row] ||= [])
        if value.nil? || value.is_a?(Cell)
          row[col] = value
        else
          cell = row[col]
          cell ? cell.value = value : row[col] = Cell.new(value, nil, nil)
        end
      end

      # Create a new cell.
      #
      # @example create a {Cell} with right aligned bold text "Hello World"
      #   table[2, 3] = table.cell('Hello World', align: right, style: 'bold')
      #
      # @param [#to_s] value text value
      # @param [:left, :right, :center] align text alignment
      # @param [String] style text style; see {Ansi.try_convert}
      # @return [Cell] a new cell
      def cell(value, align: :left, style: nil) = Cell.new(value, align, style)

      # Add a new row to the table.
      #
      # @example add a row with three right-aligned columns
      #   table.add_row('One', 'Two', 'Three', align: :right)
      #
      # @param [#map] columns Enumerable-like object containing column texts
      # @param [:left, :right, :center] align text alignment
      # @param [String] style text style; see {Ansi.try_convert}
      # @return [Table] itself
      def add_row(*columns, align: nil, style: nil)
        if columns.size == 1 && columns[0].respond_to?(:map)
          columns = columns[0]
        end
        columns = columns.map { as_cell(_1, align, style) if _1 }.to_a
        @rows << (columns.empty? ? nil : columns)
        self
      end
      alias add add_row

      # Add a new column to the table.
      #
      # @example add a column of three rows with bold styled text
      #   table.add_column('One', 'Two', 'Three', style: :bold)
      #
      # @param [#map] rows Enumerable-like object containing texts for each row
      # @param [:left, :right, :center] align text alignment
      # @param [String] style text style; see {Ansi.try_convert}
      # @return [Table] itself
      def add_column(*rows, align: nil, style: nil)
        rows = rows[0] if rows.size == 1 && rows[0].respond_to?(:map)
        row_idx = -1
        rows.each do |cell|
          (@rows[row_idx += 1] ||= []) << as_cell(cell, align, style)
        end
      end

      # Change style of one or more rows.
      #
      # @example define bold red text style for the first row
      #   table.style_row(0, 'bold red')
      #
      # @example define yellow text style for the first three rows
      #   table.style_row(0..2, 'yellow')
      #
      # @example define green text style for rows 3, 4 and 7
      #   table.style_row([3, 4, 7], 'green')
      #
      # @param [Integer, Enumerable<Integer>] row index of row(s) to change
      # @param [String, nil] style text style; see {Ansi.try_convert}
      # @return [Table] itself
      def style_row(row, style)
        if row.is_a?(Integer)
          row = [row]
        elsif !row.is_a?(Enumerable)
          raise(TypeError, "invalid row value - #{row}")
        end
        row.each { |r| @rows[r]&.each { _1&.style = style } }
        self
      end

      # Change style of one or more columns.
      #
      # @example define bold red text style for the first column
      #   table.style_column(0, 'bold red')
      #
      # @example define yellow text style for the first three columns
      #   table.style_column(0..2, 'yellow')
      #
      # @example define green text style for columns with index 3, 4 and 7
      #   table.style_column([3, 4, 7], 'green')
      #
      # @param [Integer, Enumerable<Integer>] column index of column(s) to change
      # @param [String, nil] style text style; see {Ansi.try_convert}
      # @return [Table] itself
      def style_column(column, style)
        if column.is_a?(Integer)
          column = [column]
        elsif !column.is_a?(Enumerable)
          raise(TypeError, "invalid column value - #{column}")
        end
        @rows.each { |row| column.each { row[_1]&.style = style } }
        self
      end

      # Change text alignment of one or more rows.
      #
      # @example align first row right
      #   table.align_row(0, :right)
      #
      # @example center first three rows
      #   table.align_row(0..2, :center)
      #
      # @example center the rows  with index 3, 4 and 7
      #   table.align_row([3, 4, 7], :center)
      #
      # @param [Integer, Enumerable<Integer>] row index of row(s) to change
      # @param [:left, :right, :center] alignment
      # @return [Table] itself
      def align_row(row, alignment)
        if row.is_a?(Integer)
          row = [row]
        elsif !row.is_a?(Enumerable)
          raise(TypeError, "invalid row value - #{row}")
        end
        row.each { |r| @rows[r]&.each { _1&.align = alignment } }
        self
      end

      # Change text alignment of one or more column.
      #
      # @example align first column right
      #   table.align_column(0, :right)
      #
      # @example center first three columns
      #   table.align_column(0..2, :center)
      #
      # @example center the columns  with index 3, 4 and 7
      #   table.align_column([3, 4, 7], :center)
      #
      # @param [Integer, Enumerable<Integer>] column index of column(s) to change
      # @param [:left, :right, :center] alignment
      # @return [Table] itself
      def align_column(column, alignment)
        if column.is_a?(Integer)
          column = [column]
        elsif !column.is_a?(Enumerable)
          raise(TypeError, "invalid column value - #{column}")
        end
        @rows.each { |row| column.each { row[_1]&.align = alignment } }
        self
      end

      # Convert the table to the compactest (two-dimensional) array
      # representation.
      #
      # @return [Array<Array<Cell>>]
      def to_a
        ret = []
        ridx = -1
        @rows.each do |row|
          ridx += 1
          next unless row
          count = 0
          row =
            row.map do |cell|
              next unless cell
              next if cell.value.empty?
              count += 1
              cell.dup
            end
          ret[ridx] = row if count.positive?
        end
        ret
      end

      private

      def as_cell(value, align, style)
        return Cell.new(value, align, style) unless value.is_a?(Cell)
        cell = value.dup
        cell.align = align if align
        cell.style = style if style
        cell
      end

      def initialize_copy(*)
        super
        @rows = to_a
      end

      class Cell
        # @return [String, nil] text value of the cell
        attr_reader :value

        attr_writer :align, :style

        # @!visibility private
        attr_accessor :tag

        # @!visibility private
        def initialize(value, align, style)
          @value = value.to_s
          @align = align
          @style = style
        end

        # @attribute [r] align
        # @return [:left, :right, :center] text alignment
        def align = ALIGNMENT[@align]

        # @attribute [r] style
        # @return [String, nil] text style; see {Ansi.try_convert}
        def style
          defined?(@style_) ? @style_ : @style_ = Ansi.try_convert(@style)
        end

        def value=(value)
          @value = value.to_s
        end

        private

        def initialize_copy(*)
          super
          @value = @value.dup
          @tag = nil
        end

        alignment = { left: :left, right: :right, center: :center }
        alignment.default = :left
        ALIGNMENT = alignment.compare_by_identity.freeze
      end
    end
  end

  class Wrapper
    # An {Element} to print a table.
    #
    # @see Features#table
    class Table < Element
      protected

      def call(table, frame, enlarge)
        TableGen.each_line(
          table,
          @parent.available_width - 1,
          frame,
          enlarge
        ) { @parent.puts(_1, embellish: :skip) }
        @parent
      end
    end

    # An {Element} to print key/value pairs.
    #
    # @see Features#pairs
    class Pairs < Element
      protected

      def call(kwargs, seperator)
        TableGen.each_line_simple(
          kwargs.map do |k, v|
            [
              Features::Table::Cell.new(k, :right, nil),
              Features::Table::Cell.new(v, :left, nil)
            ]
          end,
          @parent.available_width - 1,
          seperator
        ) { @parent.puts(_1, embellish: :skip) }
        @parent
      end
    end

    class TableGen
      COLOR = Ansi::FRAME_COLOR

      def self.each_line(table, max_width, frame, expand)
        gen = new(table, max_width, 3, expand)
        return unless gen.ok?
        col_div = "#{Ansi::RESET} #{COLOR}#{frame[4]}#{Ansi::RESET} "
        if frame[5]
          row_div = "#{frame[5]}#{frame[6]}#{frame[5]}"
          row_div =
            "#{COLOR}#{
              gen.widths.map { frame[5] * _1 }.join(row_div)
            }#{Ansi::RESET}"
        end
        last_row = 0
        gen.each do |number, line|
          if last_row != number
            last_row = number
            yield(row_div) if row_div
          end
          yield(line.join(col_div) + Ansi::RESET)
        end
      end

      def self.each_line_simple(table, max_width, seperator)
        gen = new(table, max_width, Text.width(seperator), false)
        return unless gen.ok?
        col_div = "#{COLOR}#{seperator}#{Ansi::RESET}"
        gen.each { yield(_2.join(col_div)) }
      end

      attr_reader :widths

      def initialize(table, max_width, coldiv_size, expand)
        return if coldiv_size > max_width # wtf
        @table = table
        @col_count = table.max_by { _1&.size || 0 }&.size || 0
        @max_width = max_width
        @widths = determine_widths
        sum = @widths.sum
        space = @max_width - ((@col_count - 1) * coldiv_size)
        if space < sum
          @widths = reduce_widths(sum, space, coldiv_size)
          adjust!
        elsif expand && sum < space
          if expand == :equal
            equal_widths(space)
          else
            enlarge_widths(sum, space)
          end
          adjust!
        end
        @empties = @widths.map { ' ' * _1 }
      end

      def ok? = @empties != nil

      def each
        ridx = -1
        @table.each do |row|
          ridx += 1
          next yield(ridx, @empties) unless row
          line_count = row.map { _1 ? _1.tag.lines.size : 0 }.max
          line_count.times do |lidx|
            cidx = -1
            yield(
              ridx,
              @empties.map do |spacer|
                cell = row[cidx += 1] or next spacer
                str, str_size = cell.tag.lines[lidx]
                next spacer unless str_size
                str_fmt(cell.align, cell.style, str, str_size, spacer.size)
              end
            )
          end
        end
        nil
      end

      private

      def str_fmt(align, style, str, str_size, size)
        return "#{style}#{str}" unless (size -= str_size).positive?
        return "#{style}#{' ' * size}#{str}" if align == :right
        if align == :center
          right = size / 2
          return "#{style}#{' ' * (size - right)}#{str}#{' ' * right}"
        end
        "#{style}#{str}#{' ' * size}"
      end

      def adjust!
        @table.each do |row|
          next unless row
          cidx = -1
          row.each do |cell|
            cidx += 1
            next unless cell
            width = @widths[cidx]
            next if cell.tag.value <= width
            cell.tag.lines = Text.as_lines([cell.value], width)
          end
        end
      end

      def enlarge_widths(sum, space)
        @widths.map! { ((((100.0 * _1) / sum) * space) / 100).round }
        return if (diff = space - @widths.sum).zero?
        @widths[
          @widths.index(diff.negative? ? @widths.max : @widths.min)
        ] += diff
      end

      def equal_widths(space)
        @widths = Array.new(@widths.size, space / @widths.size)
        @widths[-1] += space - @widths.sum
      end

      def reduce_widths(sum, space, coldiv_size)
        ws = @widths.dup
        until sum <= space
          max = ws.max
          if max == 1
            ws = @widths.take(ws.size - 1)
            sum = ws.sum
            space += coldiv_size
          else
            while (idx = ws.rindex(max)) && (sum > space)
              ws[idx] -= 1
              sum -= 1
            end
          end
        end
        ws
      end

      def determine_widths
        ret = Array.new(@col_count, 1)
        @table.each do |row|
          next unless row
          cidx = -1
          row.each do |cell|
            cidx += 1
            next unless cell
            lines = Text.as_lines([cell.value], @max_width)
            width = lines.max_by(&:last).last
            cell.tag = Tag.new(lines, width)
            ret[cidx] = width if ret[cidx] < width
          end
        end
        ret
      end

      Tag = Struct.new(:lines, :value)
    end

    private_constant :TableGen
  end
end
