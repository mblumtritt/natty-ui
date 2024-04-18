# frozen_string_literal: true

require_relative 'section'

module NattyUI
  module Features
    # Creates section with a H1 title.
    #
    # @param (see #information)
    # @yieldparam [Wrapper::Heading] heading the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Heading] itself, when no code block is given
    def h1(title, *args, &block)
      _section(self, :Heading, args, title: title, weight: 1, &block)
    end

    # Creates section with a H2 title.
    #
    # @param (see #information)
    # @yieldparam (see #h1)
    # @return (see #h1)
    def h2(title, *args, &block)
      _section(self, :Heading, args, title: title, weight: 2, &block)
    end

    # Creates section with a H3 title.
    #
    # @param (see #information)
    # @yieldparam (see #h1)
    # @return (see #h1)
    def h3(title, *args, &block)
      _section(self, :Heading, args, title: title, weight: 3, &block)
    end

    # Creates section with a H4 title.
    #
    # @param (see #information)
    # @yieldparam (see #h1)
    # @return (see #h1)
    def h4(title, *args, &block)
      _section(self, :Heading, args, title: title, weight: 4, &block)
    end

    # Creates section with a H5 title.
    #
    # @param (see #information)
    # @yieldparam (see #h1)
    # @return (see #h1)
    def h5(title, *args, &block)
      _section(self, :Heading, args, title: title, weight: 5, &block)
    end
  end

  class Wrapper
    #
    # A {Section} with a highlighted title.
    #
    # @see Features#h1
    # @see Features#h2
    # @see Features#h3
    # @see Features#h4
    # @see Features#h5
    class Heading < Section
      protected def initialize(parent, title:, weight:, **opts)
        enclose = ENCLOSE[weight]
        parent.puts(
          title,
          prefix: "[[27]]#{enclose}[[bold e7]] ",
          suffix: " [[27]]#{enclose}[[/]]"
        )
        super(parent, prefix: '  ', **opts)
        @available_width = available_width - 2
      end

      ENCLOSE = {
        1 => '═══════',
        2 => '━━━━━',
        3 => '━━━',
        4 => '───',
        5 => '──'
      }.compare_by_identity.freeze
    end
  end
end
