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
    # @yieldparam [Wrapper::Framed] framed the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Framed] itself, when no code block is given
    def framed(*args, type: :default, &block)
      _section(:Framed, args, type: NattyUI::Frame[type], &block)
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
        super(parent, prefix: "#{type[4]} ", prefix_width: 2, suffix_width: 2)
        init(type)
      end

      def init(type)
        aw = @parent.available_width - 1
        parent.puts("#{type[0]}#{type[5] * aw}")
        @finish = "#{type[2]}#{type[5] * aw}"
      end

      def finish = @parent.puts(@finish)
    end
  end
end
