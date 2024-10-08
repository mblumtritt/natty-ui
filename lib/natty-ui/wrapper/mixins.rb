# frozen_string_literal: true

module NattyUI
  #
  # Additional attributes for progression elements.
  #
  # Progression elements have additional states ({#completed?}, {#failed?}) and
  # can be closed with calling {Features#completed} or {Features#failed}.
  #
  # @see Wrapper::Progress
  # @see Wrapper::Task
  #
  module ProgressAttributes
    # @attribute [r] completed?
    # @return [Boolean] whether the task completed successfully
    def completed? = (@status == :completed)

    # @attribute [r] failed?
    # @return [Boolean] whether the task failed
    def failed? = (@status == :failed)

    # @!visibility private
    def completed(*args)
      @final_text = args unless args.empty?
      _close(:completed)
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

    def value=(value)
      @value = [0, value.to_f].max
      @max_value = @value if @max_value&.< @value
      redraw
    end

    # @return [String, nil] current information
    attr_reader :info

    def info=(value)
      @info = value
      redraw
    end

    # Maximum value.
    #
    # @return [Float] maximum value
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
