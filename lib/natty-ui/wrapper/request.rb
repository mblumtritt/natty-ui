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

      def call(question, password)
        draw(question)
        return NattyUI.in_stream.getpass if password
        NattyUI.in_stream.gets(chomp: true)
      rescue Interrupt, SystemCallError
        nil
      ensure
        finish
      end

      def draw(question)
        glyph = @parent.wrapper.glyph(:query)
        @parent.print(
          question,
          prefix: "#{glyph} ",
          prefix_width: NattyUI.display_width(glyph) + 1,
          suffix_width: 0
        )
      end
    end
  end
end
