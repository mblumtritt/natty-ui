# frozen_string_literal: true

require_relative 'section'
require_relative 'mixins'

module NattyUI
  module Features
    # Creates task section implementing additional {ProgressAttributes}.
    #
    # A task section has additional states and can be closed with {#completed}
    # or {#failed}.
    #
    # @param (see #information)
    # @yieldparam [Wrapper::Task] section the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Task] itself, when no code block is given
    def task(title, *args, &block)
      _section(:Task, args, title: title, &block)
    end
  end

  class Wrapper
    #
    # A {Message} container to visualize the progression of a task.
    #
    # @see Features.task
    class Task < Message
      include ProgressAttributes

      protected

      def initialize(parent, title:, **opts)
        @parent = parent
        @count = wrapper.lines_written
        @final_text = [title]
        super(parent, title: title, symbol: '➔', **opts)
      end

      def finish
        return @parent.failed(*@final_text) if failed?
        @status = :ok if @status == :closed
        @parent.completed(*@final_text)
      end
    end
  end
end
