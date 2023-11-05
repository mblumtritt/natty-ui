# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class Wrapper
    module Features
      # Creates a default section and prints given arguments as lines
      # into the section.
      #
      # @param [Array<#to_s>] args objects to print
      # @yieldparam [Section] section the created section
      # @return [Object] the result of the code block
      # @return [Section] itself, when no code block is given
      def section(*args, &block)
        _section(:Section, args, prefix: '  ', suffix: '  ', &block)
      end
      alias sec section

      # Creates a quotation section and prints given arguments as lines
      # into the section.
      #
      # @param (see #section)
      # @yieldparam (see #section)
      # @return (see #section)
      def quote(*args, &block)
        _section(:Section, args, prefix: '▍ ', prefix_attr: 39, &block)
      end
    end

    #
    # Visual element to keep text lines together.
    #
    # A section can contain other elements and sections.
    #
    # @see Features#section
    # @see Features#quote
    class Section < Element
      # Close the section.
      #
      # @return [Section] itself when used without a code block
      # @return [nil] when used with a code block
      def close = _close(:closed)

      # Print given arguments as lines into the section.
      #
      # @overload puts(...)
      #   @param [#to_s] ... objects to print
      #   @comment @param [#to_s, nil] prefix line prefix
      #   @comment @param [#to_s, nil] suffix line suffix
      #   @return [Section] itself
      def puts(*args, prefix: nil, suffix: nil)
        return self if @status
        @parent.puts(
          *args,
          prefix: prefix ? "#{@prefix}#{prefix}" : @prefix,
          suffix: suffix ? "#{@suffix}#{suffix}" : @suffix
        )
        self
      end
      alias add puts

      # Add at least one empty line
      #
      # @param [#to_i] lines count of lines
      # @return [Section] itself
      def space(lines = 1)
        @parent.puts(
          *Array.new([lines.to_i, 1].max),
          prefix: @prefix,
          suffix: @suffix
        )
        self
      end

      protected

      def initialize(parent, prefix: nil, suffix: nil, **_)
        super(parent)
        @prefix = prefix
        @suffix = suffix
      end

      private

      def _call
        @raise = true
        yield(self)
        close unless closed?
      rescue BREAK
        nil
      end
    end
  end
end
