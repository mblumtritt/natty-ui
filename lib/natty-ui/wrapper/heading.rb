# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    def h1(title) = _element(:Heading, title, '═══════')
    def h2(title) = _element(:Heading, title, '━━━━━')
    def h3(title) = _element(:Heading, title, '━━━')
    def h4(title) = _element(:Heading, title, '───')
    def h5(title) = _element(:Heading, title, '──')
  end

  class Wrapper
    class Heading < Element
      protected

      def call(title, enclose)
        @parent.puts(
          title,
          prefix: "#{enclose} ",
          suffix: " #{enclose}",
          max_width: available_width - 2 - (enclose.size * 2)
        )
      end
    end
  end
end
