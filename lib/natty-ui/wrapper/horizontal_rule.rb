# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Print a horizontal rule
    #
    # @param [#to_s] symbol string to build the horizontal rule
    # @return [Wrapper::Section, Wrapper] it's parent object
    def hr(symbol = '=') = _element(:HorizontalRule, symbol)
  end

  class Wrapper
    #
    # A {Element} drawing a horizontal rule.
    #
    # @see Features#hr
    class HorizontalRule < Element
      protected

      def call(symbol)
        size = NattyUI.display_width(symbol = symbol.to_s)
        return @parent.puts if size == 0
        max_width = available_width
        @parent.puts(
          symbol * ((max_width / size) - 1),
          max_width: max_width,
          prefix: Ansi[39],
          prefix_width: 0,
          suffix: Ansi::RESET,
          suffix_width: 0
        )
      end
    end
  end
end
