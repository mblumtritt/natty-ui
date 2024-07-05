# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Creates a default section and prints given arguments as lines
    # into the section.
    #
    # @param [Array<#to_s>] args optional objects to print
    # @param [String] prefix used for each printed line
    # @param [String] suffix used for each printed line
    # @yieldparam [Wrapper::Section] section the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Section] itself, when no code block is given
    def section(*args, prefix: '  ', suffix: '  ', &block)
      _section(:Section, args, prefix: prefix, suffix: suffix, &block)
    end
    alias sec section
  end

  class Wrapper
    #
    # Visual {Element} to keep text lines together.
    #
    # A section can contain other elements and sections.
    #
    # @see Features#section
    class Section < Element
      # @return [Integer] available columns count within the section
      def available_width
        @available_width ||=
          @parent.available_width - @prefix_width - @suffix_width
      end

      # Print given arguments line-wise into the section.
      #
      # @overload puts(...)
      #   @param [#to_s] ... objects to print
      #   @return [Section] itself
      def puts(*args, **kwargs)
        return self if @status
        @parent.puts(
          *args,
          **kwargs.merge!(
            prefix: "#{@prefix}#{kwargs[:prefix]}",
            prefix_width: @prefix_width + kwargs[:prefix_width].to_i,
            suffix: "#{kwargs[:suffix]}#{@suffix}",
            suffix_width: @suffix_width + kwargs[:suffix_width].to_i
          )
        )
        self
      end

      # Print given arguments into the section.
      #
      # @overload print(...)
      #   @param [#to_s] ... objects to print
      #   @return [Section] itself
      def print(*args, **kwargs)
        return self if @status
        @parent.print(
          *args,
          **kwargs.merge!(
            prefix: "#{@prefix}#{kwargs[:prefix]}",
            prefix_width: @prefix_width + kwargs[:prefix_width].to_i,
            suffix: "#{kwargs[:suffix]}#{@suffix}",
            suffix_width: @suffix_width + kwargs[:suffix_width].to_i
          )
        )
        self
      end

      # Add at least one empty line
      #
      # @param [#to_i] lines count of lines
      # @return [Section] itself
      def space(lines = 1) = puts("\n" * [1, lines.to_i].max)

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

      # @!visibility private
      def inspect = @status ? "#{_to_s[..-2]} status=#{@status}>" : _to_s

      # @!visibility private
      def rcol = @parent.rcol - @suffix_width

      protected

      def initialize(
        parent,
        prefix:,
        prefix_width: NattyUI.display_width(prefix),
        suffix: nil,
        suffix_width: NattyUI.display_width(suffix)
      )
        super(parent)
        @prefix = prefix
        @suffix = suffix
        @prefix_width = prefix_width
        @suffix_width = suffix_width
      end
    end
  end
end
