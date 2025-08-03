# frozen_string_literal: true

require 'terminal/text'
require_relative 'width_finder'

module NattyUI
  class TableRenderer
    def self.[](table, max_width)
      columns = table.columns.map(&:width)
      return [] if columns.empty?
      attributes = table.attributes
      unless attributes.border_chars.nil?
        max_width -= (columns.size - 1)
        max_width -= 2 if attributes.border_around
      end
      return [] if max_width < columns.size
      new(columns, table.each.to_a, attributes, max_width).lines
    end

    attr_reader :lines

    private

    def initialize(columns, rows, attributes, max_width)
      @max_width, @columns = WidthFinder.find(columns, max_width)
      init_borders(attributes)
      @columns = @columns.each.with_index

      @lines = render(rows.shift)
      @lines.unshift(@b_top) if @b_top

      if @b_between
        rows.each do |row|
          @lines << @b_between
          @lines += render(row)
        end
      else
        rows.each { |row| @lines += render(row) }
      end

      @lines << @b_bottom if @b_bottom
    end

    def render(row)
      cells = @columns.map { |cw, i| Cell.new(row[i], cw) }
      height = cells.max_by { _1.text.size }.text.size
      cells.each { _1.correct_height(height) }
      Array.new(height) do |line|
        "#{@b_outer}#{cells.map { _1.text[line] }.join(@b_inner)}#{@b_outer}"
      end
    end

    def init_borders(attributes)
      chars = attributes.border_chars or return
      style = border_style(attributes)
      @b_inner = style[chars[9]]
      return if chars[10] == ' '
      return init_borders_around(chars, style) if attributes.border_around
      @b_between = chars[10] * (@max_width + @columns.size - 1)
      i = -1
      @columns[0..-2].each { |w| @b_between[i += w + 1] = chars[4] }
      @b_between = style[@b_between]
    end

    def init_borders_around(chars, style)
      fw = chars[10] * (@max_width + @columns.size - 1)
      @b_top = "#{chars[0]}#{fw}#{chars[2]}"
      @b_bottom = "#{chars[6]}#{fw}#{chars[8]}"
      @b_between = "#{chars[3]}#{fw}#{chars[5]}"
      i = 0
      @columns[0..-2].each do |w|
        @b_top[i += w + 1] = chars[1]
        @b_bottom[i] = chars[7]
        @b_between[i] = chars[4]
      end
      @b_top = style[@b_top]
      @b_bottom = style[@b_bottom]
      @b_between = style[@b_between]
      @b_outer = @b_inner
    end

    def border_style(attributes)
      style = attributes.border_style_bbcode
      style ? ->(line) { "#{style}#{line}[/]" } : lambda(&:itself)
    end

    class Cell
      attr_reader :width, :text

      def correct_height(height)
        return self if (diff = height - @text.size) <= 0
        @text =
          case @vertical
          when :bottom
            [Array.new(diff, @empty), @text]
          when :middle
            tc = diff / 2
            [Array.new(tc, @empty), @text, Array.new(diff - tc, @empty)]
          else
            [@text, Array.new(diff, @empty)]
          end.flatten(1)
        self
      end

      def initialize(cell, width)
        return @text = [] unless cell
        att = cell.attributes
        @padding = att.padding.dup
        @align = att.align
        @vertical = att.vertical
        @style = att.style_bbcode
        @text = width_corrected(cell.text, width)
      end

      private

      def width_corrected(text, width)
        @width, @padding[3], @padding[1] =
          WidthFinder.adjust(width, @padding[3], @padding[1])
        @empty = @style ? "#{@style}#{' ' * width}[/]" : ' ' * width
        [
          Array.new(@padding[0], @empty),
          Text.each_line_with_size(
            *text,
            limit: @width,
            bbcode: true,
            ansi: Terminal.ansi?
          ).map(&txt_fmt),
          Array.new(@padding[2], @empty)
        ].flatten(1)
      end

      def txt_fmt
        lpad, rpad = pads
        case @align
        when :right
          ->(txt, w) { "#{lpad}#{' ' * (@width - w)}#{txt}#{rpad}" }
        when :centered
          lambda do |txt, w|
            s = @width - w
            "#{lpad}#{' ' * (lw = s / 2)}#{txt}#{' ' * (s - lw)}#{rpad}"
          end
        else
          ->(txt, w) { "#{lpad}#{txt}#{' ' * (@width - w)}#{rpad}" }
        end
      end

      def pads
        return ' ' * @padding[3], "[/]#{' ' * @padding[1]}" unless @style
        ["#{@style}#{' ' * @padding[3]}", "#{' ' * @padding[1]}[/]"]
      end
    end
  end
  private_constant :TableRenderer
end
