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
    #   @param [#map<#map<#to_s>>] args one or more arrays representing rows of the table
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
      type = NattyUI.frame(type)
      return _element(:Table, table, type) unless block_given?
      yield(table = Table.new(table))
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
      _element(:Pairs, kwargs.to_a, seperator)
    end

    class Table
      attr_reader :rows

      def add_row(*columns)
        columns = columns[0] if columns.size == 1 && columns[0].is_a?(Array)
        @rows << columns
        self
      end
      alias add add_row

      def add_col(*rows)
        rows = rows[0] if rows.size == 1 && rows[0].is_a?(Array)
        row_idx = -1
        rows.each { |row| (@rows[row_idx += 1] ||= []) << row }
        self
      end

      def initialize(rows) = (@rows = rows)
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
        TableGen.each_line(rows, @parent.available_width - 1, type) do |line|
          @parent.puts(line)
        end
        @parent
      end

      def coloring = [nil, nil]
    end

    # An {Element} to print key/value pairs.
    #
    # @see Features#pairs
    class Pairs < Element
      protected

      def call(rows, seperator)
        TableGen.each_simple(
          rows,
          @parent.available_width - 1,
          seperator
        ) { |line| @parent.puts(line) }
        @parent
      end
    end

    class TableGen
      COLOR = Ansi[39]

      class << self
        def each_line(rows, max_width, frame)
          gen = new(rows, max_width, 3)
          return unless gen.ok?
          col_div = " #{COLOR}#{frame[4]}#{Ansi::RESET} "
          row_div = "#{frame[5]}#{frame[6]}#{frame[5]}"
          row_div =
            "#{COLOR}#{
              gen.widths.map { frame[5] * _1 }.join(row_div)
            }#{Ansi::RESET}"
          last_row = 0
          gen.each do |number, line|
            if last_row != number
              last_row = number
              yield(row_div)
            end
            yield(line.join(col_div))
          end
        end

        def each_simple(rows, max_width, seperator)
          gen = new(rows, max_width, 3)
          return unless gen.ok?
          seperator = seperator.to_s
          gen.alignments[0] = :right if Text.plain(seperator)[1] == ' '
          gen.each { yield(_2.join(seperator)) }
        end
      end

      attr_reader :widths, :alignments

      def ok? = @alignments != nil

      def initialize(rows, max_width, coldiv_size)
        @tab = rows.map { |row| row.map { |col| col.to_s.lines(chomp: true) } }
        col_count = @tab.max_by(&:size)&.size or return
        return if col_count.zero?
        coldiv_sum = (col_count - 1) * coldiv_size
        max_col_width = max_width - col_count - coldiv_sum
        @widths = Array.new(col_count, 1)
        if max_col_width > 1
          @tab.each do |row|
            row.each_with_index do |col, idx|
              next if col.empty?
              width = col.map { Text.width(_1) }.max
              width = max_col_width if width > max_col_width
              @widths[idx] = width if @widths[idx] < width
            end
          end
        end
        if (size = max_width - coldiv_sum) < @widths.sum
          @widths = adjusted_sizes(widths, size, coldiv_size)
        end
        @alignments = Array.new(col_count, :left)
      end

      def each
        unless @empties
          @tab = adjust(@tab, @widths)
          @empties = @widths.map { ' ' * _1 }
        end
        @tab.each_with_index do |row, ridx|
          line_count = row.max_by(&:size).size
          line_count.times do |line_nr|
            cidx = -1
            yield(ridx, @empties.map { row.dig(cidx += 1, line_nr) || _1 })
          end
        end
      end

      private

      def str_align(how, str, str_size, size)
        return str unless (size -= str_size).positive?
        return str + (' ' * size) if how == :left
        (' ' * size) + str
      end

      def adjust(tab, widths)
        tab.each do |row|
          idx = -1
          row.map! do |col|
            width = widths[idx += 1]
            next col if col.empty?
            lines = []
            Text.each_embellished_line(col, width) do |line, size|
              lines << str_align(@alignments[idx], line, size, width)
            end
            lines
          end
        end
      end

      def adjusted_sizes(widths, size, coldiv_size)
        ws = widths.dup
        sum = ws.sum
        until sum <= size
          max = ws.max
          if max == 1
            ws = widths.take(ws.size - 1)
            sum = ws.sum
            size += coldiv_size
          else
            while (idx = ws.rindex(max)) && (sum > size)
              ws[idx] -= 1
              sum -= 1
            end
          end
        end
        ws
      end
    end

    private_constant :TableGen
  end
end
