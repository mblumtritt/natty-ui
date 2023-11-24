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
    # @yieldparam [Wrapper::Task] task the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Task] itself, when no code block is given
    def task(title, *args, &block)
      _section(self, :Task, args, title: title, &block)
    end
  end

  module TaskMethods
    protected

    def initialize(parent, title:, **opts)
      @parent = parent
      @temp = wrapper.temporary
      @final_text = [title]
      super(parent, title: title, symbol: :task, **opts)
    end

    def finish
      return @parent.failed(*@final_text) if failed?
      @temp.call
      _section(
        @parent,
        :Message,
        @final_text,
        title: @final_text.shift,
        symbol: @status = :completed
      )
    end
  end
  private_constant :TaskMethods

  class Wrapper
    #
    # A {Message} container to visualize the progression of a task.
    #
    # @see Features.task
    class Task < Message
      include ProgressAttributes
      include TaskMethods
    end
  end
end
