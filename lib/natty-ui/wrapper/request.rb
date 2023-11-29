# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Request user input.
    #
    # @param question [#to_s] Question to display
    # @param password [Boolean] whether to hide the input
    # @return [String] the user input
    # @return [nil] when input was aborted with `^C` or `^D`
    def request(question, password: false)
      _element(:Request, question, password)
    end
  end

  class Wrapper
    #
    # An {Element} to request user input.
    #
    # @see Features#request
    class Request < Element
      protected

      def _call(question, password)
        return read_password(question) if password
        NattyUI.readline(prompt(question), stream: wrapper.stream)
      ensure
        finish
      end

      def read_password(question)
        (wrapper.stream << prompt(question)).flush
        NattyUI.in_stream.getpass
      rescue Interrupt
        nil
      end

      def prompt(question) = "#{prefix}▶︎ #{question}: "
    end
  end
end
