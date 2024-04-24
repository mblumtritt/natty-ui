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
    # @param [#to_s] title object to print as section title
    # @param [Array<#to_s>] args more objects to print
    # @param [Symbol] type frame type;
    #   valid types are `:rounded`, `:simple`, `:heavy`, `:semi`, `:double`
    # @yieldparam [Wrapper::Framed] framed the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Framed] itself, when no code block is given
    def framed(*args, type: :rounded, &block)
      _section(:Framed, args, type: type, &block)
    end
  end

  class Wrapper
    #
    # A frame-enclosed {Section} with a highlighted title.
    #
    # @see Features#framed
    class Framed < Section
      protected

      def initialize(parent, type:)
        @type = FRAME_PARTS[type] or
          raise(ArgumentError, "invalid frame type - #{type.inspect}")
        parent.puts(
          color("#{@type[0]}#{@type[1] * (parent.available_width - 2)}")
        )
        super(parent, prefix: "#{color(@type[4])} ", prefix_width: 2)
        @suffix = ' '
        @suffix_width = 1
      end

      def finish
        @parent.puts(
          color("#{@type[3]}#{@type[1] * (@parent.available_width - 2)}")
        )
      end

      def color(str) = str

      FRAME_PARTS = {
        rounded: '╭─╮╰│╯',
        simple: '┌─┐└│┘',
        heavy: '┏━┓┗┃┛',
        double: '╔═╗╚║╝',
        semi: '╒═╕╘│╛'
      }.freeze
    end
  end
end
