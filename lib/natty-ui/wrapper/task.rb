# frozen_string_literal: true

require_relative 'section'

module NattyUI
  class Wrapper
    module Features
      # Creates task section implementing additional {TaskAttributes}.
      #
      # A task section has additional states and can be closed with {#completed}
      # or {#failed}.
      #
      # @param (see #information)
      # @yieldparam [Task] section the created section
      # @return [Object] the result of the code block
      # @return [Task] itself, when no code block is given
      def task(title, *args, &block)
        _section(:Task, args, title: title, &block)
      end
    end

    # Mix-in for task section states.
    #
    # @see Task
    #
    module TaskAttributes
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

    # A {Message} container to visualize the progression of a task.
    #
    # @see Features.task
    class Task < Message
      include TaskAttributes
    end
  end
end
