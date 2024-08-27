# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Prints a H1 title.
    #
    # @param [#to_s] title text
    # @param [#to_i] space space around the heading
    # @return [Wrapper::Section, Wrapper] it's parent object
    def h1(title, space: 0) = _element(:Heading, title, space, '═══════')

    # Prints a H2 title.
    #
    # @param (see #h1)
    # @return (see #h1)
    def h2(title, space: 0) = _element(:Heading, title, space, '━━━━━')

    # Prints a H3 title.
    #
    # @param (see #h1)
    # @return (see #h1)
    def h3(title, space: 0) = _element(:Heading, title, space, '━━━')

    # Prints a H4 title.
    #
    # @param (see #h1)
    # @return (see #h1)
    def h4(title, space: 0) = _element(:Heading, title, space, '───')

    # Prints a H5 title.
    #
    # @param (see #h1)
    # @return (see #h1)
    def h5(title, space: 0) = _element(:Heading, title, space, '──')
  end

  class Wrapper
    #
    # A {Element} drawing a title.
    #
    # @see Features#h1
    # @see Features#h2
    # @see Features#h3
    # @see Features#h4
    # @see Features#h5
    class Heading < Element
      protected

      def call(title, space, enclose)
        (space = space.to_i).positive? and (before = space / 2).positive? and
          @parent.space(before)
        @parent.puts(
          title,
          prefix: "#{Ansi::FRAME_COLOR}#{enclose} #{Ansi[:bold, 255]}",
          suffix: " #{Ansi[:bold_off, 39]}#{enclose}#{Ansi::RESET}",
          max_width: available_width - 2 - (enclose.size * 2)
        )
        before ? @parent.space(space - before) : @parent
      end
    end
  end
end
