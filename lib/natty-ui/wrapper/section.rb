# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class Wrapper
    #
    # Helper class representing a output section.
    #
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
    private_constant :Message

    class Heading < Section
      protected

      def initialize(parent, title:, weight:, **opts)
        prefix, suffix = enclose(weight)
        parent.puts(title, prefix: prefix, suffix: suffix)
        super(parent, **opts)
      end

      def enclose(weight)
        enclose = ENCLOSE[weight]
        return "#{enclose} ", " #{enclose}" if enclose
        raise(ArgumentError, "invalid heading weight - #{weight}")
      end

      ENCLOSE = {
        1 => '═══════',
        2 => '━━━━━',
        3 => '━━━',
        4 => '───',
        5 => '──'
      }.compare_by_identity.freeze
    end
    private_constant :Heading

    class Framed < Section
      protected

      def initialize(parent, title:, type:, **opts)
        top_start, top_suffix, left, bottom = components(type)
        parent.puts(" #{title} ", prefix: top_start, suffix: top_suffix)
        @bottom = bottom
        super(parent, prefix: "#{left} ", **opts)
      end

      def finish = parent.puts(@bottom)

      def components(type)
        COMPONENTS[type] || raise(ArgumentError, "invalid frame type - #{type}")
      end

      COMPONENTS = {
        rounded: %w[╭── ───── │ ╰──────────],
        simple: %w[┌── ───── │ └──────────],
        heavy: %w[┏━━ ━━━━━ ┃ ┗━━━━━━━━━━],
        semi: %w[┍━━ ━━━━━ │ ┕━━━━━━━━━━],
        double: %w[╔══ ═════ ║ ╚══════════]
      }.compare_by_identity.freeze
    end
    private_constant :Framed

    # Extension for task section states.
    #
    # @see Features.task
    #
    module TaskMixin
      # @attribute [r] ok?
      # @return [Boolean] whether the task completed sucessfully
      def ok? = (@status == :ok)

      # @attribute [r] failed?
      # @return [Boolean] whether the task failed
      def failed? = (@status == :failed)

      # @!visibility private
      def completed(*args)
        @args = args unless args.empty?
        _close(:ok)
      end
      alias done completed
      alias ok completed

      # @!visibility private
      def failed(*args)
        @args = args unless args.empty?
        _close(:failed)
      end

      protected

      def initialize(parent, title:, **opts)
        @parent = parent
        @count = wrapper.lines_written
        @args = [title]
        super(parent, title: title, symbol: '➔', **opts)
      end

      def finish
        return @parent.failed(*@args) if failed?
        @status = :ok if @status == :closed
        cleanup
        @parent.completed(*@args)
      end

      def cleanup = nil
    end

    class Task < Message
      include TaskMixin
    end
    private_constant :Task
  end
end
