# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Creates a default section and prints given arguments as lines
    # into the section.
    #
    # @param [Array<#to_s>] args objects to print
    # @yieldparam [Wrapper::Section] section the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Section] itself, when no code block is given
    def section(*args, &block)
      _section(self, :Section, args, prefix: '  ', suffix: '  ', &block)
    end
    alias sec section

    # Creates a quotation section and prints given arguments as lines
    # into the section.
    #
    # @param (see #section)
    # @yieldparam (see #section)
    # @return (see #section)
    def quote(*args, &block)
      _section(self, :Section, args, prefix: '▍ ', prefix_attr: 39, &block)
    end
  end

  class Wrapper
    #
    # Visual {Element} to keep text lines together.
    #
    # A section can contain other elements and sections.
    #
    # @see Features#section
    # @see Features#quote
    class Section < Element
      # Close the section.
      #
      # @return [Section] itself
      def close = _close(:closed)

      # Print given arguments as lines into the section.
      # Optionally limit the line width to given `max_width`.
      #
      # @overload puts(..., max_width: nil)
      #   @param [#to_s] ... objects to print
      #   @param [Integer, nil] max_width maximum line width
      #   @comment @param [#to_s, nil] prefix line prefix
      #   @comment @param [#to_s, nil] suffix line suffix
      #   @return [Section] itself
      def puts(*args, max_width: nil, prefix: nil, suffix: nil)
        return self if @status
        @parent.puts(
          *args,
          max_width: max_width,
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
          "\n" * ([lines.to_i, 1].max - 1),
          prefix: @prefix,
          suffix: @suffix
        )
        self
      end

      # @note The screen manipulation is only available in ANSI mode see {#ansi?}
      #
      # Resets the part of the screen written below the current output line when
      # the given block ended.
      #
      # @example
      #   section.temporary do |temp|
      #     temp.info('This message will disappear in 5 seconds!')
      #     sleep 5
      #   end
      #
      # @yield [Section] itself
      # @return [Object] block result
      def temporary = block_given? ? yield(self) : self

      protected

      def initialize(parent, prefix: nil, suffix: nil, **_)
        super(parent)
        @prefix = prefix
        @suffix = suffix
      end
    end
  end
end
