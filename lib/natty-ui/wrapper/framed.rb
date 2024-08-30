# frozen_string_literal: true

require_relative 'section'

module NattyUI
  module Features
    # Creates frame-enclosed section with a highlighted `title` and
    # prints given additional arguments as lines into the section.
    #
    # When no block is given, the section must be closed, see
    # {Wrapper::Element#close}.
    #
    # @param [Array<#to_s>] args more objects to print
    # @param [Symbol, String] type frame type; see {NattyUI::Frame}
    # @param [Integer, Array<Integer>] text padding
    # @yieldparam [Wrapper::Framed] framed the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Framed] itself, when no code block is given
    def framed(*args, type: :default, padding: [0, 1], &block)
      _section(
        :Framed,
        args,
        title: args.shift,
        type: NattyUI::Frame[type],
        padding: padding,
        &block
      )
    end
  end

  class Wrapper
    #
    # A frame-enclosed {Section} with a highlighted title.
    #
    # @see Features#framed
    class Framed < Section
      protected

      def initialize(parent, title:, type:, padding:)
        @pt, @pr, @pb, @pl = *as_padding(padding)
        super(
          parent,
          prefix: "#{type[4]}#{' ' * @pl}",
          prefix_width: @pl + 1,
          suffix_width: @pr + 1
        )
        init(title, type)
        space(@pt) if @pt.positive?
      end

      def init(title, type)
        width = parent.available_width - 1
        @finish = "#{type[2]}#{type[5] * width}"
        parent.puts(
          if title
            "#{type[0]}#{type[5]}#{type[10]} #{title} #{type[9]}#{
              type[5] * (width - 5 - Text.width(title))
            }"
          else
            "#{type[0]}#{type[5] * width}"
          end
        )
      end

      def finish
        if @pb.positive?
          stat, @status = @status, nil
          space(@pb)
          @status = stat
        end
        @parent.puts(@finish)
      end

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

      def as_uint(value) = [value.to_i, 0].max
    end
  end
end
