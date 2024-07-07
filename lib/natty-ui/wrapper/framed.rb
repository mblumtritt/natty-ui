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
    # @param [:block, :double, :heavy, :rounded, :semi, :simple] type frame type
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
        deco = as_deco(type)
        super(parent, prefix: "#{deco[0]} ", prefix_width: 2, suffix_width: 2)
        init(deco)
      end

      def as_deco(type)
        if type.is_a?(Symbol)
          ret = DECO[type] and return ret
        elsif type.is_a?(String)
          return type if type.size == 8
          return type * 8 if type.size == 1
        end
        raise(ArgumentError, "invalid frame type - #{type.inspect}")
      end

      def init(deco)
        aw = @parent.available_width - 1
        parent.puts("#{deco[1]}#{deco[2] * aw}")
        @finish = "#{deco[5]}#{deco[6] * aw}"
      end

      def finish = @parent.puts(@finish)

      DECO = {
        rounded: '│╭─╮│╰─╯',
        simple: '│┌─┐│└─┘',
        heavy: '┃┏━┓┃┗━┛',
        double: '║╔═╗║╚═╝',
        semi: '│╒═╕│╘═╛',
        block: '▌▛▀▜▐▙▄▟'
      }.compare_by_identity.freeze
    end
  end
end
