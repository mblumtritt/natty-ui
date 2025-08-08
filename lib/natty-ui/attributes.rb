# frozen_string_literal: true

module NattyUI
  # @todo This chapter needs more documentation.
  #
  module Attributes
    class Base
      # @return [Attributes] updated copy of itself
      def merge(**attributes)
        attributes.empty? ? dup : dup._assign(attributes)
      end

      # @return [Attributes] itself
      def merge!(**attributes)
        attributes.empty? ? self : _assign(attributes)
      end

      # @!visibility private
      def to_hash
        _store({})
      end

      # @!visibility private
      def to_h(&block)
        block ? _store({}).to_h(&block) : _store({})
      end

      private

      def initialize(**attributes)
        _init
        _assign(attributes) unless attributes.empty?
      end

      def _init = nil
      def _assign(_opt) = self
      def _store(opt) = opt

      def as_uint(value) = [0, value.to_i].max
      def as_nint(value) = ([0, value.to_i].max if value)

      def as_wh(value)
        return unless value
        return value > 0 ? value : nil if value.is_a?(Numeric)
        value.is_a?(Range) ? wh_from(value.begin, value.end) : nil
      end

      def wh_from(min, max)
        min = normalized(min)
        max = normalized(max)
        return max ? (..max) : nil unless min
        return Range.new(min, nil) unless max
        min == max ? min : Range.new(*[min, max].minmax)
      end

      def normalized(value)
        return value < 0 ? nil : value if value.is_a?(Float) && value < 1
        (value = value.to_i) < 1 ? nil : value
      end
    end

    module Align
      # Horizontal element alignment.
      #
      # @return [:left, :right, :centered]
      attr_reader :align

      # @attribute [w] align
      def align=(value)
        @align = Utils.align(value)
      end

      protected

      def _init
        @align = :left
        super
      end

      def _assign(opt)
        self.align = opt[:align] if opt.key?(:align)
        super
      end

      def _store(opt)
        opt[:align] = @align if @align != :left
        super
      end
    end

    module Vertical
      # Vertical element alignment.
      #
      # @return [:top, :bottom, :middle]
      attr_reader :vertical

      # @attribute [w] vertical
      def vertical=(value)
        @vertical = Utils.vertical(value)
      end

      protected

      def _init
        @vertical = :top
        super
      end

      def _assign(opt)
        self.vertical = opt[:vertical] if opt.key?(:vertical)
        super
      end

      def _store(opt)
        opt[:vertical] = @vertical if @vertical != :top
        super
      end
    end

    module Width
      # Element width.
      #
      # @return [Integer] dedicated element width
      # @return [Range] width range: {#min_width}..{#max_width}
      # @return [nil] when unassigned
      attr_reader :width

      # @attribute [w] width
      def width=(value)
        @width = as_wh(value)
      end

      # Minimum element width.
      #
      # @attribute [r] min_width
      # @return [Integer, nil]
      def min_width
        width.is_a?(Range) ? @width.begin : @width
      end

      # @attribute [w] min_width
      def min_width=(value)
        @width = wh_from(value, max_width)
      end

      # Maximum element width.
      #
      # @attribute [r] max_width
      # @return [Integer, nil]
      def max_width
        width.is_a?(Range) ? @width.end : @width
      end

      # @attribute [w] max_width
      def max_width=(value)
        @width = wh_from(min_width, value)
      end

      protected

      def _assign(opt)
        @width = as_wh(opt[:width]) if opt.key?(:width)
        self.min_width = opt[:min_width] if opt.key?(:min_width)
        self.max_width = opt[:max_width] if opt.key?(:max_width)
        super
      end

      def _store(opt)
        opt[:width] = @width if @width
        super
      end
    end

    module Height
      # Element height.
      #
      # @return [Integer] dedicated element height
      # @return [Range] height range: {#min_height}..{#max_height}
      # @return [nil] when unassigned
      attr_reader :height

      # @attribute [w] height
      def height=(value)
        @height = as_wh(value)
      end

      # Minimum element height.
      #
      # @attribute [r] min_height
      # @return [Integer, nil]
      def min_height
        @height.is_a?(Range) ? @height.begin : @height
      end

      # @attribute [w] min_height
      def min_height=(value)
        @height = wh_from(value.to_i, max_height)
      end

      # Maximum element height.
      #
      # @attribute [r] max_height
      # @return [Integer, nil]
      def max_height
        @height.is_a?(Range) ? @height.begin : @height
      end

      # @attribute [w] max_height
      def max_height=(value)
        @height = wh_from(min_height, value.to_i)
      end

      protected

      def _assign(opt)
        @height = as_wh(opt[:height]) if opt.key?(:height)
        self.min_height = opt[:min_height] if opt.key?(:min_height)
        self.max_height = opt[:max_height] if opt.key?(:max_height)
        super
      end

      def _store(opt)
        opt[:height] = @height if @height
        super
      end
    end

    module Padding
      # Text padding within the element.
      #
      # @return [Array<Integer>] top, right, bottom, left
      attr_reader :padding

      # @attribute [w] padding
      def padding=(*value)
        @padding = Utils.padding(*value).freeze
      end

      # Text top padding.
      #
      # @attribute [r] padding_top
      # @return [Integer]
      def padding_top = @padding[0]

      # @attribute [w] padding_top
      def padding_top=(value)
        @padding[0] = as_uint(value)
      end

      # Text right padding.
      #
      # @attribute [r] padding_right
      # @return [Integer]
      def padding_right = @padding[1]

      # @attribute [w] padding_right
      def padding_right=(value)
        @padding[1] = as_uint(value)
      end

      # Text bottom padding.
      #
      # @attribute [r] padding_bottom
      # @return [Integer]
      def padding_bottom = @padding[2]

      # @attribute [w] padding_bottom
      def padding_bottom=(value)
        @padding[2] = as_uint(value)
      end

      # Text left padding.
      #
      # @attribute [r] padding_left
      # @return [Integer]
      def padding_left = @padding[3]

      # @attribute [w] padding_left
      def padding_left=(value)
        @padding[3] = as_uint(value)
      end

      protected

      def _init
        @padding = Array.new(4, 0)
        super
      end

      def _assign(opt)
        self.padding = opt[:padding] if opt.key?(:padding)
        @padding[0] = as_uint(opt[:padding_top]) if opt.key?(:padding_top)
        @padding[1] = as_uint(opt[:padding_right]) if opt.key?(:padding_right)
        @padding[2] = as_uint(opt[:padding_bottom]) if opt.key?(:padding_bottom)
        @padding[3] = as_uint(opt[:padding_left]) if opt.key?(:padding_left)
        super
      end

      def _store(opt)
        val = @padding.dup
        if val[1] == val[3]
          val.pop
          if val[0] == val[2]
            if val[0] == val[1]
              opt[:padding] = val[0] if val[0] != 0
              return super
            end
            val.pop
          end
        end
        opt[:padding] = val
        super
      end

      def initialize_copy(*_)
        super
        @padding = @padding.dup
      end
    end

    module Margin
      # Element margin.
      #
      # @return [Array<Integer>] [top, right, bottom, left]
      attr_reader :margin

      # @attribute [w] margin
      def margin=(*value)
        @margin = Utils.margin(*value).freeze
      end

      # Element top margin.
      #
      # @attribute [r] margin_top
      # @return [Integer]
      def margin_top = @margin[0]

      # @attribute [w] margin_top
      def margin_top=(value)
        @margin[0] = as_uint(value)
      end

      # Element right margin.
      #
      # @attribute [r] margin_right
      # @return [Integer]
      def margin_right = @margin[1]

      # @attribute [w] margin_right
      def margin_right=(value)
        @margin[1] = as_uint(value)
      end

      # Element bottom margin.
      #
      # @attribute [r] margin_bottom
      # @return [Integer]
      def margin_bottom = @margin[2]

      # @attribute [w] margin_bottom
      def margin_bottom=(value)
        @margin[2] = as_uint(value)
      end

      # Element left margin.
      #
      # @attribute [r] margin_left
      # @return [Integer]
      def margin_left = @margin[3]

      # @attribute [w] margin_left
      def margin_left=(value)
        @margin[3] = as_uint(value)
      end

      protected

      def _init
        @margin = Array.new(4, 0)
        super
      end

      def _assign(opt)
        self.margin = opt[:margin] if opt.key?(:margin)
        @margin[0] = as_uint(opt[:margin_top]) if opt.key?(:margin_top)
        @margin[1] = as_uint(opt[:margin_right]) if opt.key?(:margin_right)
        @margin[2] = as_uint(opt[:margin_bottom]) if opt.key?(:margin_bottom)
        @margin[3] = as_uint(opt[:margin_left]) if opt.key?(:margin_left)
        super
      end

      def _store(opt)
        val = @margin.dup
        if val[1] == val[3]
          val.pop
          if val[0] == val[2]
            if val[0] == val[1]
              opt[:margin] = val[0] if val[0] != 0
              return super
            end
            val.pop
          end
        end
        opt[:margin] = val
        super
      end

      def initialize_copy(*_)
        super
        @margin = @margin.dup
      end
    end

    module Style
      # Text style.
      #
      # @return [Array, nil]
      attr_reader :style

      # @attribute [w] style
      def style=(value)
        @style = Utils.style(value)
      end

      def style_bbcode
        "[#{@style.join(' ')}]" if @style
      end

      protected

      def _assign(opt)
        @style = Utils.style(opt[:style]) if opt.key?(:style)
        super
      end

      def _store(opt)
        opt[:style] = @style if @style
        super
      end
    end

    module BorderStyle
      # Border style.
      #
      # @return [Array, nil]
      attr_reader :border_style

      # @attribute [w]  border_style
      def border_style=(value)
        @border_style = Utils.style(value)
      end

      def border_style_bbcode
        "[#{@border_style.join(' ')}]" if @border_style
      end

      protected

      def _assign(opt)
        @border_style = Utils.style(opt[:border_style]) if opt.key?(
          :border_style
        )
        super
      end

      def _store(opt)
        opt[:border_style] = @border_style if @border_style
        super
      end
    end

    module BorderAround
      # Whether the border is around an element.
      #
      # @return [true, false]
      attr_reader :border_around

      # @attribute [w]  border_around
      def border_around=(value)
        @border_around = value ? true : false
      end

      protected

      def _assign(opt)
        @border_around = opt[:border_around]
        super
      end

      def _store(opt)
        opt[:border_around] = true if @border_around
        super
      end
    end

    module Border
      # Border type.
      #
      # @return [
      #   :default,
      #   :rounded,
      #   :heavy,
      #   :double,
      #   :vintage,
      #   :defaulth,
      #   :defaultv,
      #   :heavyh,
      #   :heavyv,
      #   :doubleh,
      #   :doublev
      #   ]
      # @return [nil] when element has no border
      attr_reader :border

      # @attribute [w] border
      def border=(value)
        if value
          @border_chars = Theme.current.border(value)
          @border = value
        else
          @border_chars = @border = nil
        end
      end

      # @!visibility private
      # @return [String, nil]
      attr_reader :border_chars

      protected

      def _assign(opt)
        self.border = opt[:border] if opt.key?(:border)
        super
      end

      def _store(opt)
        opt[:border] = @border if @border_chars
        super
      end
    end
  end

  module WithAttributes
    attr_reader :attributes

    def attributes=(value)
      @attributes =
        if value.is_a?(self.class::Attributes)
          value.dup
        elsif value.respond_to?(:to_hash)
          self.class::Attributes.new(**value.to_hash)
        else
          self.class::Attributes.new(**value.to_h)
        end
    end

    private

    def initialize(**attributes)
      @attributes = self.class::Attributes.new(**attributes)
    end

    def initialize_copy(*_)
      super
      @attributes = @attributes.dup
    end
  end
  private_constant :WithAttributes

  module TextWithAttributes
    include WithAttributes

    attr_reader :text

    def empty? = @text.empty?

    alias _to_s to_s
    private :_to_s

    def to_str = @text.join("\n")
    alias to_s to_str

    def inspect
      if (att = @attributes.to_hash).empty?
        "#{_to_s.chop} @text=#{to_s.inspect}>"
      else
        "#{_to_s.chop} @attributes=#{att} @text=#{to_s.inspect}>"
      end
    end

    private

    def initialize(*text, **attributes)
      @text = text
      @attributes =
        if text.last.is_a?(self.class::Attributes)
          text.pop.merge(**@attributes)
        else
          self.class::Attributes.new(**attributes)
        end
    end

    def initialize_copy(*_)
      super
      @text = @text.map(&:dup)
    end
  end
  private_constant :TextWithAttributes
end
