# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Print a horizontal rule
    #
    # @param [#to_s] symbol string to build the horizontal rule
    # @return [Wrapper, Wrapper::Element] itself
    def hr(symbol = '=') = _element(:HorizontalRule, symbol)
  end

  class Wrapper
    class HorizontalRule < Element
      protected

      def call(symbol)
        msg, max_width = determine(symbol)
        msg ? @parent.puts(msg, max_width: max_width) : @parent.puts
      end

      def determine(symbol)
        size = _cleared_width(symbol = symbol.to_s)
        return if size == 0
        max_width = available_width
        [symbol * ((max_width / size) - 1), max_width]
      end
    end
  end
end
