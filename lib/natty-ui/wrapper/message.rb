# frozen_string_literal: true

require_relative 'section'

module NattyUI
  module Features
    # Creates a simple message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param [#to_s] title object to print as section title
    # @param [Array<#to_s>] args more objects to print
    # @param [#to_s] glyph glyph/prefix used for the title
    # @yieldparam [Wrapper::Message] message the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Message] itself, when no code block is given
    def message(title, *args, glyph: :default, &block)
      _section(self, :Message, args, title: title, glyph: glyph, &block)
    end
    alias msg message

    # Creates a informational message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param [#to_s] title object to print as section title
    # @param [Array<#to_s>] args more objects to print
    # @yieldparam (see #message)
    # @return (see #message)
    def information(title, *args, &block)
      _section(self, :Message, args, title: title, glyph: :information, &block)
    end
    alias info information

    # Creates a warning message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param (see #information)
    # @yieldparam (see #message)
    # @return (see #message)
    def warning(title, *args, &block)
      _section(self, :Message, args, title: title, glyph: :warning, &block)
    end
    alias warn warning

    # Creates a error message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param (see #information)
    # @yieldparam (see #message)
    # @return (see #message)
    def error(title, *args, &block)
      _section(self, :Message, args, title: title, glyph: :error, &block)
    end
    alias err error

    # Creates a completion message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # When used for a {#task} section it closes this section with status `:ok`.
    #
    # @param (see #information)
    # @yieldparam (see #message)
    # @return (see #message)
    def completed(title, *args, &block)
      _section(self, :Message, args, title: title, glyph: :completed, &block)
    end
    alias done completed
    alias ok completed

    # Creates a failure message section with a highlighted `title` and
    # prints given additional arguments as lines into the section.
    #
    # When used for a {#task} section it closes this section with status
    # `:failed`.
    #
    # @param (see #information)
    # @yieldparam (see #message)
    # @return (see #message)
    def failed(title, *args, &block)
      _section(self, :Message, args, title: title, glyph: :failed, &block)
    end
  end

  class Wrapper
    #
    # A {Section} with a highlighted title.
    #
    # @see Features#message
    # @see Features#information
    # @see Features#warning
    # @see Features#error
    # @see Features#completed
    # @see Features#failed
    class Message < Section
      protected

      def initialize(parent, title:, glyph:, **opts)
        @parent = parent
        prefix_width, attributes = prefix_info(glyph)
        parent.puts(title, **attributes)
        super(parent, prefix: ' ' * prefix_width, **opts)
        @available_width = available_width - 2
      end

      def prefix_info(glyph)
        glyph = wrapper.glyph(glyph)
        [_cleared_width(glyph) + 1, { prefix: "#{glyph} " }]
      end
    end
  end
end
