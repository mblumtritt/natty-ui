# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Creates a quotation section and prints given arguments as lines
    # into the section.
    #
    # @param (see #section)
    # @yieldparam (see #section)
    # @return (see #section)
    def quote(*args, &block) = _section(:Quote, args, prefix: '▍ ', &block)
  end

  class Wrapper
    Quote = Class.new(Section)
  end
end
