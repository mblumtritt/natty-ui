# frozen_string_literal: true

require_relative 'frame'

module NattyUI
  module Render
    class Line
      attr_accessor :size, :alignment, :style

      def self.create(*strs, max_width: 0x7ffffff)
        ret = []
        Text.each_line(strs, max_width) { |*a| ret << new(*a) }
        ret.empty? ? [new('', 0)] : ret
      end

      def self.create_empty(size) = Line.new(' ' * size, size)

      def initialize(text, size)
        @text = text
        @size = @org_size = size
      end

      def assign(size: nil, style: nil, alignment: nil)
        @size = [@org_size, size].max if size
        @style = style if style
        @alignment = alignment if alignment
      end

      def join(*lines)
        return Line.new(to_s, @size) if lines.empty?
        lines.unshift(self)
        Line.new(lines.join, lines.sum(&:size))
      end

      def reset! = (@size = @org_size)

      def to_s = @style ? "#{@style}#{aligned}#{Ansi::RESET}" : aligned

      private

      def aligned
        return @text if @size == @org_size
        case @alignment
        when :right
          "#{' ' * (@size - @org_size)}#{@text}"
        when :center
          width = @size - @org_size
          fill = ' ' * (width / 2)
          "#{fill}#{@text}#{' ' * (width - fill.size)}"
        else
          "#{@text}#{' ' * (@size - @org_size)}"
        end
      end
    end

    class Multiline
      def self.create(*strs, max_width: 0x7ffffff, **options)
        new(Line.create(*strs, max_width: max_width), **options)
      end

      def initialize(lines)
        @lines = lines.empty? ? [Line.new('', 0)] : lines
      end

      attr_accessor :valign
      attr_reader :lines

      def max_size = @lines.max_by(&:size).size
      def to_s = @lines.join("\n")

      def normalize!(size: nil, style: nil, alignment: nil)
        style = Ansi.try_convert(style) if style
        @lines.each do |line|
          line.assign(size: size, style: style, alignment: alignment)
        end
        self
      end

      def vpad!(top, bottom)
        return self if top <= 0 && bottom <= 0
        line = Line.create_empty(max_size)
        @lines = Array.new(top, line) + @lines unless top <= 0
        @lines += Array.new(bottom, line) unless bottom <= 0
        self
      end

      def hpad!(left, right)
        if left <= 0
          return self if right <= 0
          right = Line.create_empty(right)
          @lines.map! { _1.join(right) }
          return self
        end
        left = Line.create_empty(left)
        if right <= 0
          @lines.map! { left.join(_1) }
          return self
        end
        right = Line.create_empty(right)
        @lines.map! { left.join(_1, right) }
        self
      end

      def in_height(height)
        return self if (height -= @lines.size) <= 0
        case valign
        when :center, :middle
          pt = height / 2
          dup.vpad!(pt, height - pt)
        when :bottom
          dup.vpad!(height, 0)
        else
          dup.vpad!(0, height)
        end
      end

      def join(*other) = other.empty? ? self : _join(self, *other)

      private

      def _join(*all)
        height = all.max_by { _1.lines.size }.lines.size
        all.map! { _1.in_height(height) }
        first = all.shift
        lines = Array.new(height)
        first.lines.each_with_index do |line, idx|
          lines[idx] = line.join(*all.map { _1.lines[idx] })
        end
        Multiline.new(lines)
      end

      def initialize_copy(*)
        super
        @lines = @lines.map(&:dup)
      end
    end

    class Column < Multiline
      def initialize(block, size)
        super(block.lines)
        normalize!(size: size, style: block.style, alignment: block.align)
        hpad!(block.padding_left, block.padding_right)
        vpad!(block.padding_top, block.padding_bottom)
      end
    end

    class FramedColumn < Column
      def initialize(block, size)
        super
        frame = Frame[block.frame || :default]
        frame_style = block.frame_style || Ansi::FRAME_COLOR
        w = @lines[0].size
        line = Line.new(frame[4], 1)
        line.style = frame_style
        @lines.map! { line.join(_1, line) }
        line = Line.new("#{frame[0]}#{frame[5] * w}#{frame[1]}", w + 2)
        line.style = frame_style
        @lines.unshift(line)
        line = Line.new("#{frame[2]}#{frame[5] * w}#{frame[3]}", w + 2)
        line.style = frame_style
        @lines.push(line)
      end
    end

    class Columns
      def initialize(max_width, blocks)
        @max_width = max_width
        @blocks = blocks
      end

      def to_s
        as_rows
          .map! do |row|
            optimize_row(row)
            first = row.map!(&:to_column).shift
            row.empty? ? first : first.join(*row)
          end
          .join("\n")
      end

      private

      def as_rows
        items =
          @blocks.filter_map do |block|
            item = Item.new(block, @max_width)
            item if item.min_width <= @max_width
          end
        rows = [current = []]
        cmw = 0
        until items.empty?
          item = items.shift
          if (cmw += item.min_width) <= @max_width
            next current << item
          end
          rows << (current = [item])
          cmw = item.min_width
        end
        rows
      end

      def optimize_row(row)
        until row.sum(&:size) < @max_width
          var = row.find_all(&:variable?)
          break if var.empty?
          rm = var[0]
          var.each { |item| rm = item if item.size >= rm.size }
          rm.size -= 1
        end
      end

      class Item
        attr_reader :block, :overhead, :min_width
        attr_accessor :size

        def variable? = @size > @min_width

        def initialize(block, max_width)
          @block = block
          @overhead = block.padding_left + block.padding_right
          @overhead += 2 if block.frame
          @min_width = @overhead + (block.width || block.min_width || 1)
          return if @min_width > max_width
          @space = max_width - @overhead
          reset_size!
        end

        def reset_size!
          return @size = block.width + @overhead if block.width
          lines = Line.create(*@block.lines, max_width: @space)
          @size = lines.max_by(&:size).size + @overhead
        end

        def to_column
          w = @size - @overhead
          @block.lines.replace(Line.create(*@block.lines, max_width: w))
          ret = (@block.frame ? FramedColumn : Column).new(@block, w)
          ret.valign = @block.valign
          ret
        end
      end
    end
  end
end
