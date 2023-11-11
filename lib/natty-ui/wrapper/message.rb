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
    # @yieldparam [Wrapper::Message] message the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Message] itself, when no code block is given
    def message(title, *args, symbol: :default, &block)
      _section(self, :Message, args, title: title, symbol: symbol, &block)
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
      _section(self, :Message, args, title: title, symbol: :information, &block)
    end
    alias info information

    # Creates a warning message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param (see #information)
    # @yieldparam (see #message)
    # @return (see #message)
    def warning(title, *args, &block)
      _section(self, :Message, args, title: title, symbol: :warning, &block)
    end
    alias warn warning

    # Creates a error message section with a highlighted `title`  and
    # prints given additional arguments as lines into the section.
    #
    # @param (see #information)
    # @yieldparam (see #message)
    # @return (see #message)
    def error(title, *args, &block)
      _section(self, :Message, args, title: title, symbol: :error, &block)
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
      _section(self, :Message, args, title: title, symbol: :completed, &block)
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
      _section(self, :Message, args, title: title, symbol: :failed, &block)
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
        parent.puts(title, **title_attr(str = as_symbol_str(symbol), symbol))
        super(parent, prefix: ' ' * (NattyUI.display_width(str) + 1), **opts)
      end

      def title_attr(str, _symbol) = { prefix: "#{str} " }
      def as_symbol_str(symbol) = (SYMBOL[symbol] || symbol)

      SYMBOL = {
        default: '•',
        information: 'i',
        warning: '!',
        error: 'X',
        completed: '✓',
        failed: 'F',
        query: '▶︎',
        task: '➔'
      }.compare_by_identity.freeze
    end
  end
end
