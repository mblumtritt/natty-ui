# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    #
    # Table view of data.
    #
    # @note Tables do not support text attributes yet and are still under
    #   construction. This means table features are not complete defined and
    #   may change in near future.
    #
    # Defined values for `type` are
    # :double, :heavy, :semi, :simple
    #
    # @overload table(type: simple)
    #   Construct and display a table.
    #
    #   @param [Symbol] type frame type
    #   @yieldparam [Table] table construction helper
    #   @return [Wrapper::Section, Wrapper] it's parent object
    #
    #   @example
    #    ui.table do |table|
    #      table.add('name', 'price', 'origin')
    #      table.add('apple', '1$', 'California')
    #      table.add('banana', '2$', 'Brasil')
    #      table.add('kiwi', '1.5$', 'Newzeeland')
    #    end
    #
    #    # output:
    #    # name   │ price │ origin
    #    # ───────┼───────┼───────────
    #    # apple  │ 1$    │ California
    #    # ───────┼───────┼───────────
    #    # banana │ 2$    │ Brasil
    #    # ───────┼───────┼───────────
    #    # kiwi   │ 1.5$  │ Newzeeland
    #
    # @overload table(*args, type: simple)
    #   Display the given arrays as rows of a table.
    #
    #   @param [Array<#to_s>] args one or more arrays representing rows of the table
    #   @param [Symbol] type frame type
    #   @return [Wrapper::Section, Wrapper] it's parent object
    #
    #   @example
    #     ui.table(
    #       %w[name price origin],
    #       %w[apple 1$ California],
    #       %w[banana 2$ Brasil],
    #       %w[kiwi 1.5$ Newzeeland]
    #     )
    def table(*table, type: :simple)
      table = Table.new(*table)
      yield(table) if block_given?
      _element(:Table, table.rows, type)
    end

    #
    # Table-like display of key/value pairs.
    #
    # @param [#to_s] seperator
    # @param [Hash<#to_s,#to_s>] kwargs
    # @return [Wrapper::Section, Wrapper] it's parent object
    #
    # @example
    #   ui.pairs(apple: '1$', banana: '2$', kiwi: '1.5$')
    #
    #   # output:
    #   #  apple: 1$
    #   # banana: 2$
    #   #   kiwi: 1.5$
    #
    def pairs(seperator = ': ', **kwargs)
      _element(:Pairs, Table.new(**kwargs).rows, seperator)
    end

    class Table
      attr_reader :rows

      def add_row(*columns)
        @rows << columns
        self
      end
      alias add add_row

      def add_col(*columns)
        columns.each_with_index do |col, row_idx|
          (@rows[row_idx] ||= []) << col
        end
        self
      end

      def initialize(*args, **kwargs)
        @rows = []
        args.each { add_row(*_1) }
        kwargs.each_pair { add_row(*_1) }
      end
    end
    private_constant :Table
  end

  class Wrapper
    # An {Element} to print a table.
    #
    # @see Features#table
    class Table < Element
      protected

      def call(rows, type)
        TableGenerator.each_line(
          rows,
          @parent.available_width - 1,
          ORNAMENTS[type] ||
            raise(ArgumentError, "invalid table type - #{type.inspect}"),
          Ansi[39],
          Ansi::RESET
        ) { @parent.puts(_1) }
        @parent
      end

      def coloring = [nil, nil]

      ORNAMENTS = {
        rounded: '│─┼',
        simple: '│─┼',
        heavy: '┃━╋',
        double: '║═╬',
        semi: '║╴╫'
      }.compare_by_identity.freeze
    end

    # An {Element} to print key/value pairs.
    #
    # @see Features#pairs
    class Pairs < Element
      protected

      def call(rows, seperator)
        TableGenerator.each_simple_line(
          rows,
          @parent.available_width - 1,
          seperator,
          NattyUI.plain(seperator, ansi: false)[-1] == ' '
        ) { @parent.puts(_1) }
        @parent
      end
    end

    class TableGenerator
      def self.each_line(rows, max_width, ornament, opref, osuff)
        return if rows.empty?
        gen = new(rows, max_width, 3)
        return unless gen.ok?
        last_row = 0
        col_div = " #{opref}#{ornament[0]}#{osuff} "
        row_div = "#{ornament[1]}#{ornament[2]}#{ornament[1]}"
        row_div =
          "#{opref}#{gen.widths.map { ornament[1] * _1 }.join(row_div)}#{osuff}"
        gen.each do |line, number|
          if last_row != number
            last_row = number
            yield(row_div)
          end
          yield(line.join(col_div))
        end
      end

      def self.each_simple_line(rows, max_width, col_div, first_right)
        return if rows.empty?
        gen = new(rows, max_width, NattyUI.display_width(col_div))
        return unless gen.ok?
        gen.aligns[0] = :right if first_right
        gen.each { yield(_1.join(col_div)) }
      end

      attr_reader :widths, :aligns

      def initialize(rows, max_width, col_div_size)
        @rows =
          rows.map do |row|
            row.map do |col|
              col = NattyUI.embellish(col).each_line(chomp: true).to_a
              col.empty? ? col << '' : col
            end
          end
        @max_width = max_width
        @col_div_size = col_div_size
        @widths = create_widths.freeze
        @aligns = Array.new(@widths.size, :left)
      end

      def ok? = (@widths != nil)

      def each
        return unless @widths
        col_empty = @widths.map { ' ' * _1 }
        @rows.each_with_index do |row, row_idx|
          row
            .max_by(&:size)
            .size
            .times do |line_nr|
              col_idx = -1
              yield(
                @widths.map do |col_width|
                  cell = row[col_idx += 1] or next col_empty[col_idx]
                  next col_empty[col_idx] if (line = cell[line_nr]).nil?
                  align(line.to_s, col_width, @aligns[col_idx])
                end,
                row_idx
              )
            end
        end
      end

      private

      def align(str, width, alignment)
        return str unless (width -= NattyUI.display_width(str)).positive?
        return str + (' ' * width) if alignment == :left
        (' ' * width) << str
      end

      def create_widths
        matrix = create_matrix
        col_widths = find_col_widths(matrix)
        adjusted = adjusted_widths(col_widths)
        return if adjusted.empty? # nothing to draw
        return adjusted if col_widths == adjusted # all fine
        if (size = adjusted.size) != col_widths.size
          @rows.map! { _1.take(size) }
          matrix.map! { _1.take(size) }
          col_widths = col_widths.take(size)
        end
        diff = diff(col_widths, adjusted)
        @rows.each_with_index do |row, row_idx|
          diff.each do |col_idx|
            adjust_to = adjusted[col_idx]
            next if matrix[row_idx][col_idx] <= adjust_to
            ary = NattyUI.each_line(*row[col_idx], max_width: adjust_to).to_a
            ary.pop if ary.last.empty?
            row[col_idx] = ary
          end
        end
        adjusted
      end

      def create_matrix
        ret =
          @rows.map do |row|
            row.map { |col| col.map { NattyUI.display_width(_1) }.max }
          end
        cc = ret.max_by(&:size).size
        ret.each { (add = cc - _1.size).nonzero? and _1.fill(0, _1.size, add) }
      end

      def find_col_widths(matrix)
        ret = nil
        matrix.each do |row|
          next ret = row.dup unless ret
          row.each_with_index do |size, idx|
            hs = ret[idx]
            ret[idx] = size if hs < size
          end
        end
        ret
      end

      def adjusted_widths(col_widths)
        ret = col_widths.dup
        left = @max_width - (@col_div_size * (col_widths.size - 1))
        return ret if ret.sum <= left
        indexed = ret.each_with_index.to_a
        # TODO: optimize this!
        until ret.sum <= left
          indexed.sort! { |b, a| (a[0] <=> b[0]).nonzero? || (a[1] <=> b[1]) }
          pair = indexed[0]
          next ret[pair[1]] = pair[0] if (pair[0] -= 1).nonzero?
          indexed.shift
          return [] if indexed.empty?
          ret.pop
        end
        ret
      end

      def diff(col_widths, adjusted)
        ret = []
        col_widths.each_with_index do |val, idx|
          ret << idx if val != adjusted[idx]
        end
        ret
      end
    end
    private_constant :TableGenerator
  end
end
