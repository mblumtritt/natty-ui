# frozen_string_literal: true

module NattyUI
  # Helper class to define text lines with attributes.
  #
  # @see Columns
  class Cell
    # Horizontal text alignment.
    # Valid values are `:left` (_default_), `:right`, `:center`.
    #
    # @return [Symbol, nil]
    attr_accessor :align

    # Type of frame.
    #
    # @see Frame
    #
    # @return [Symbol, nil]
    attr_accessor :frame

    # Style of the {frame}.
    #
    # @see Ansi.try_convert
    #
    # @return [String, nil]
    attr_accessor :frame_style

    # Text lines.
    #
    # @return [Array<#to_s>]
    attr_reader :lines

    # Minimal width of the cell.
    #
    # @return [Integer, nil]
    attr_reader :min_width

    def min_width=(value)
      @min_width = as_uint(value)
      @min_width = nil if @min_width.zero?
    end

    # Cell padding.
    #
    # @example Set all padding values to same value
    #   cell.padding = 2
    #   # cell.padding => [2, 2, 2, 2]
    #
    # @example Set top/bottom and left/right padding to different values
    #   cell.padding = [1, 2]
    #   # cell.padding => [1, 2, 1, 2]
    #
    # @example Set top, bottom and left/right padding
    #   cell.padding = [1, 3, 2]
    #   # cell.padding => [1, 3, 2, 3]
    #
    # @example Set top, bottom, left, right padding to different values
    #   cell.padding = [1, 2, 3, 4]
    #   # cell.padding => [1, 2, 3, 4]
    #
    # @see padding_top
    # @see padding_right
    # @see padding_bottom
    # @see padding_left
    #
    # @attribute [r] padding
    # @return [padding_top, padding_right, padding_bottom, padding_left]
    def padding
      [@padding_top, @padding_right, @padding_bottom, @padding_left]
    end

    # @attribute [w] padding
    def padding=(value)
      @padding_top, @padding_right, @padding_bottom, @padding_left =
        as_padding(value)
    end

    # Padding at bottom of the cell.
    #
    # @see padding
    #
    # @return [Integer]
    attr_reader :padding_bottom

    def padding_bottom=(value)
      @padding_bottom = as_uint(value)
    end

    # Padding at left of the cell.
    #
    # @see padding
    #
    # @return [Integer]
    attr_reader :padding_left

    def padding_left=(value)
      @padding_left = as_uint(value)
    end

    # Padding at right of the cell.
    #
    # @see padding
    #
    # @return [Integer]
    attr_reader :padding_right

    def padding_right=(value)
      @padding_right = as_uint(value)
    end

    # Padding at top of the cell.
    #
    # @see padding
    #
    # @return [Integer]
    attr_reader :padding_top

    def padding_top=(value)
      @padding_top = as_uint(value)
    end

    # Text style to be used for {lines}.
    #
    # @see Ansi.try_convert
    #
    # @return [String, nil]
    attr_accessor :style

    # Vertical text alignment.
    # Valid values are `:top` (_default_), `:bottom`, `:center`.
    #
    # @return [Symbol, nil]
    attr_accessor :valign

    # Width of the cell.
    # Can be unset, a fixed value or evaluated.
    #
    # @return [Integer, :content, :max, nil]
    attr_reader :width

    def width=(value)
      @width =
        case value
        when :content, :max, nil
          value
        else
          (value = value.to_i).positive? ? value : nil
        end
    end

    # @!visibility private
    attr_accessor :tag

    # Assign attributes.
    #
    # @param options [Hash] attributes to assign
    # @option options [Symbol] :align {align}
    # @option options [Symbol] :frame {frame}
    # @option options [String] :frame_style {frame_style}
    # @option options [Integer] :min_width {min_width}
    # @option options [Integer, Array<Integer>] :padding {padding}
    # @option options [Integer] :padding_bottom {padding_bottom}
    # @option options [Integer] :padding_left {padding_left}
    # @option options [Integer] :padding_right {padding_right}
    # @option options [Integer] :padding_top {padding_top}
    # @option options [String] :style {style}
    # @option options [Symbol] :valign {valign}
    # @option options [Integer, :content, :max] :width {width}
    # @return [Cell] itself
    def set(**options)
      return self if options.empty?
      options.key?(:align) and @align = options[:align]
      options.key?(:frame) and @frame = options[:frame]
      options.key?(:frame_style) and @frame_style = options[:frame_style]
      options.key?(:min_width) and self.min_width = options[:min_width]
      options.key?(:padding) and self.padding = options[:padding]
      assign_padding(options)
      options.key?(:style) and @style = options[:style]
      options.key?(:valign) and @valign = options[:valign]
      options.key?(:width) and self.width = options[:width]
      self
    end

    # @param lines [#to_s] one or more text lines
    # @param options [Hash] attributes to assign
    # @option options [Symbol] :align {align}
    # @option options [Symbol] :frame {frame}
    # @option options [String] :frame_style {frame_style}
    # @option options [Integer] :min_width {min_width}
    # @option options [Integer, Array<Integer>] :padding {padding}
    # @option options [Integer] :padding_bottom {padding_bottom}
    # @option options [Integer] :padding_left {padding_left}
    # @option options [Integer] :padding_right {padding_right}
    # @option options [Integer] :padding_top {padding_top}
    # @option options [String] :style {style}
    # @option options [Symbol] :valign {valign}
    # @option options [Integer, :content, :max] :width {width}
    def initialize(*lines, **options)
      @lines = lines.flatten
      if options.empty?
        self.padding = 0
        return
      end
      @align = options[:align]
      @frame = options[:frame]
      @frame_style = options[:frame_style]
      self.min_width = options[:min_width]
      self.padding = options[:padding]
      assign_padding(options)
      @style = options[:style]
      @valign = options[:valign]
      self.width = options[:width]
    end

    # @!visibility private
    def to_s = @lines.join("\n")

    private

    def as_padding(value)
      return Array.new(4, as_uint(value)) unless value.is_a?(Enumerable)
      case value.size
      when 1, 2
        tb = as_uint(value[0])
        rl = as_uint(value[1])
        [tb, rl, tb, rl]
      when 3
        rl = as_uint(value[1])
        [as_uint(value[0]), rl, as_uint(value[2]), rl]
      else
        value.map { as_uint(_1) }
      end
    end

    def assign_padding(options)
      opt = ->(n) { [options[n].to_i, 0].max if options.key?(n) }
      value = opt[:padding_bottom] and @padding_bottom = value
      value = opt[:padding_left] and @padding_left = value
      value = opt[:padding_right] and @padding_right = value
      value = opt[:padding_top] and @padding_top = value
    end

    def as_uint(value) = [value.to_i, 0].max

    def initialize_copy(*)
      super
      @lines = @lines.map(&:dup)
    end
  end

  # Helper class to define a {Cell} collection.
  #
  # @see Features#columns
  class Columns
    def self.create(*texts, **options)
      ret = new
      texts.each { ret.add(_1, **options) }
      ret
    end

    def initialize = (@ll = [])

    # Number of cells.
    #
    # @attribute [r] count
    # @return [Integer]
    def count = @ll.size

    # Set horizontal text alignment of all cells.
    #
    # @see Cell#align
    #
    # @attribute [w] align
    # @return (see Cell#align)
    def align=(value)
      each { _1.align = value }
    end

    # Set frame type of all cells.
    #
    # @see Cell#frame
    #
    # @attribute [w] frame
    # @return (see Cell#frame)
    def frame=(value)
      each { _1.frame = value }
    end

    # Set frame style of all cells.
    #
    # @see Cell#frame_style
    #
    # @attribute [w] frame_style
    # @return (see Cell#frame_style)
    def frame_style=(value)
      each { _1.frame_style = value }
    end

    # Set minimal width of all cells.
    #
    # @see Cell#min_width
    #
    # @attribute [w] min_width
    # @return (see Cell#min_width)
    def min_width=(value)
      each { _1.min_width = value }
    end

    # Set padding of all cells.
    #
    # @see Cell#padding
    #
    # @attribute [w] padding
    # @return (see Cell#padding)
    def padding=(value)
      each { _1.padding = value }
    end

    # Set padding at bottom of all cells.
    #
    # @see Cell#padding_bottom
    #
    # @attribute [w] padding_bottom
    # @return (see Cell#padding_bottom)
    def padding_bottom=(value)
      each { _1.padding_bottom = value }
    end

    # Set padding at left of all cells.
    #
    # @see Cell#padding_left
    #
    # @attribute [w] padding_left
    # @return (see Cell#padding_left)
    def padding_left=(value)
      each { _1.padding_left = value }
    end

    # Set padding at right of all cells.
    #
    # @see Cell#padding_right
    #
    # @attribute [w] padding_right
    # @return (see Cell#padding_right)
    def padding_right=(value)
      each { _1.padding_right = value }
    end

    # Set padding at top of all cells.
    #
    # @see Cell#padding_top
    #
    # @attribute [w] padding_top
    # @return (see Cell#padding_top)
    def padding_top=(value)
      each { _1.padding_top = value }
    end

    # Set text style of all cells.
    #
    # @see Cell#style
    #
    # @attribute [w] style
    # @return (see Cell#style)
    def style=(value)
      each { _1.style = value }
    end

    # Set vertical alignment of all cells.
    #
    # @see Cell#valign
    #
    # @attribute [w] valign
    # @return (see Cell#valign)
    def valign=(value)
      each { _1.valign = value }
    end

    # Set width of all cells.
    #
    # @see Cell#width
    #
    # @attribute [w] width
    # @return (see Cell#width)
    def width=(value)
      each { _1.width = value }
    end

    # Access a cell.
    #
    # @param index [Integer] cell index
    # @return [Cell]
    def at(index) = (@ll[index] ||= Cell.new)
    alias [] at

    # Assign attributes to all cells.
    #
    # @see Cell#set
    #
    # @param options [Hash] attributes to assign
    # @return [Columns] itself
    def set(**options)
      each { _1.set(**options) } unless options.empty?
      self
    end

    # Add a new cell.
    #
    # @see Cell#initialize
    #
    # @param lines (see Cell#initialize)
    # @param options (see Cell#initialize)
    # @return [Cell]
    def add(*lines, **options)
      @ll << (block = Cell.new(*lines, **options))
      block
    end
    alias append add

    # Add many cells with same attributes.
    #
    # @example Create three cells with same padding
    #   cc.add_many("Cell 1", "Cell 2", "Cell 3", padding: [1, 2])
    #
    # @see Cell#initialize
    #
    # @param texts [Array<#to_s>] texts to create cells
    # @param options (see Cell#initialize)
    # @return [Array<Cell>]
    def add_many(*texts, **options) = texts.map { add(_1, **options) }

    # Delete the cell at given position.
    #
    # @param index [Integer] delete position
    # @return [Cell, nil]
    def delete(index) = @ll.delete_at(index)

    # Insert a new cell at a position.
    #
    # @see Cell#initialize
    #
    # @param index [Integer] insert position
    # @param lines (see Cell#initialize)
    # @param options (see Cell#initialize)
    # @return [Cell]
    def insert(index, *lines, **options)
      @ll.insert(index, block = Cell.new(*lines, **options))
      block
    end

    # Prepend a new cell first cell.
    #
    # @see Cell#initialize
    #
    # @param lines (see Cell#initialize)
    # @param options (see Cell#initialize)
    # @return [Cell]
    def prepend(*lines, **options) = insert(0, *lines, **options)

    # Convert the collection into an Array.
    #
    # @return [Array<Cell>]
    def to_a = @ll.map { _1.dup || Cell.new }

    private

    def each = @ll.each { yield(_1) if _1 }
  end

  # Helper class to define a table.
  #
  # @see Features#table
  class TableEx
    def initialize = @ll = []

    # Number of rows.
    #
    # @attribute [r] count
    # @return [Integer]
    def count = @ll.size

    # Access a row.
    #
    # @param index [Integer] row index
    # @return [Cell]
    def at(index) = (@ll[index] ||= Columns.new)
    alias [] at

    # Add a new row.
    #
    # @see Cell#initialize
    #
    # @param texts [Array<#to_s>] texts to create cells
    # @param options (see Cell#initialize)
    # @return [Columns]
    def add(*texts, **options)
      @ll << (row = Columns.create(*texts, **options))
      row
    end
    alias append add

    # Delete the row at given position.
    #
    # @param index [Integer] delete position
    # @return [Columns, nil]
    def delete(index) = @ll.delete_at(index)

    # Insert a new row at a position.
    #
    # @see Cell#initialize
    #
    # @param index [Integer] insert position
    # @param texts [Array<#to_s>] texts to create cells
    # @param options (see Cell#initialize)
    # @return [Columns]
    def insert(index, *texts, **options)
      @ll.insert(index, (row = Columns.create(*texts, **options)))
      row
    end

    # Prepend a new row.
    #
    # @see Cell#initialize
    #
    # @param texts [Array<#to_s>] texts to create cells
    # @param options (see Cell#initialize)
    # @return [Columns]
    def prepend(*texts, **options) = insert(0, *texts, **options)

    # Assign attributes to all rows.
    #
    # @see Cell#set
    #
    # @param options [Hash] attributes to assign
    # @return [TableEx] itself
    def set(**options)
      @ll.each { _1&.set(**options) } unless options.empty?
      self
    end

    # Assign attributes to a column.
    #
    # @see Cell#set
    #
    # @param index [Integer] column index
    # @param options [Hash] attributes to assign
    # @return [TableEx] itself
    def set_column(index, **options)
      @ll.each { _1&.at(index)&.set(**options) } unless options.empty?
      self
    end

    # Convert the collection into an Array.
    #
    # @return [Array<Array<Cell>>]
    def to_a = @ll.map(&:to_a)
  end
end