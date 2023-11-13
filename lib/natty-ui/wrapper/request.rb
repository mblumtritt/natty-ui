# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Request user input.
    #
    # @param question [#to_s] Question to display
    # @return [String] the user input
    # @return [nil] when input was aborted with `^C` or `^D`
    def request(question)
      _element(:Request, question)
    end
  end

  class Wrapper
    #
    # An {Element} to request user input.
    #
    # @see Features#request
    class Request < Element
      protected

      def _call(question)
        NattyUI.readline(prompt(question), stream: wrapper.stream)
      ensure
        finish
      end

      def prompt(question) = "#{prefix}▶︎ #{question}: "
    end
  end
end
