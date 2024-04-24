# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Creates a quotation section and prints given arguments as lines
    # into the section.
    #
    # @param (see #section)
    # @yieldparam (see #section)
    # @return [Object] the result of the code block
    # @return [Wrapper::Quote] itself, when no code block is given
    def quote(*args, &block) = _section(:Quote, args, prefix: '▍ ', &block)
  end

  class Wrapper
    #
    # A quotation {Section}.
    #
    # @see Features#quote
    class Quote < Section
    end
  end
end
