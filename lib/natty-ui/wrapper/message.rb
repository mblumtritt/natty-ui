# frozen_string_literal: true

require_relative 'section'

module NattyUI
  module Features
    # Creates a simple message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param [#to_s] title object to print as section title
    # @param [Array<#to_s>] args more objects to print
    # @param [#to_s] symbol symbol/prefix used for the title
    # @yieldparam [Wrapper::Message] section the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Message] itself, when no code block is given
    def message(title, *args, symbol: '•', &block)
      _section(:Message, args, title: title, symbol: symbol, &block)
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
      _section(:Message, args, title: title, symbol: 'i', &block)
    end
    alias info information

    # Creates a warning message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param (see #information)
    # @yieldparam (see #message)
    # @return (see #message)
    def warning(title, *args, &block)
      _section(:Message, args, title: title, symbol: '!', &block)
    end
    alias warn warning

    # Creates a error message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param (see #information)
    # @yieldparam (see #message)
    # @return (see #message)
    def error(title, *args, &block)
      _section(:Message, args, title: title, symbol: 'X', &block)
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
      _section(:Message, args, title: title, symbol: '✓', &block)
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
      _section(:Message, args, title: title, symbol: 'F', &block)
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

      def initialize(parent, title:, symbol:, **opts)
        parent.puts(title, **title_attr(symbol))
        super(parent, prefix: ' ' * (NattyUI.display_width(symbol) + 1), **opts)
      end

      def title_attr(symbol)
        { prefix: "#{symbol} " }
      end
    end
  end
end
