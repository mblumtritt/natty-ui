# frozen_string_literal: true

module NattyUI
  #
  # Additional attributes for progression elements.
  #
  # Progression elements have additional states ({#ok?}, {#failed?}) and can be
  # closed/finalized with calling {Features#completed} or {Features#failed}.
  #
  # @see Wrapper::Progress
  # @see Wrapper::Task
  #
  module ProgressAttributes
    # @attribute [r] ok?
    # @return [Boolean] whether the task completed sucessfully
    def ok? = (@status == :ok)

    # @attribute [r] failed?
    # @return [Boolean] whether the task failed
    def failed? = (@status == :failed)

    # @!visibility private
    def completed(*args)
      @final_text = args unless args.empty?
      _close(:ok)
    end
    alias done completed
    alias ok completed

    # @!visibility private
    def failed(*args)
      @final_text = args unless args.empty?
      _close(:failed)
    end
  end

  #
  # Additional attributes for progression elements.
  #
  # @see Wrapper::Progress
  #
  module ValueAttributes
    # @return [Float] current value
    attr_reader :value

    def value=(val)
      @value = [0, val.to_f].max
      @max_value = @value if @max_value&.< 0
      redraw
    end

    # Maximal value.
    #
    # @return [Float] maximal value
    # @return [nil] when no max_value was configured
    attr_reader :max_value

    # Increase the value by given amount.
    #
    # @param increment [#to_f] value increment
    # @return [Wrapper::Element] itself
    def step(increment = 1)
      self.value = @value + increment.to_f
      self
    end
  end
end
