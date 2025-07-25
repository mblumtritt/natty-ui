# frozen_string_literal: true

module NattyUI
  # @todo This chapter needs more documentation.
  #
  # Progress indictaor helper used by {Features.progress}.
  #
  module ProgressHelper
    # @return [String]
    attr_reader :title

    # @attribute [w] title
    def title=(value)
      @title = value
      redraw
    end

    # @return [Float]
    attr_reader :value

    # @attribute [w] value
    def value=(val)
      @value = val.to_f
      @value = 0.0 if @value < 0
      @max = @value if @max&.<(@value)
      redraw
    end

    # @return [Float]
    attr_reader :max

    # @attribute [w] max
    def max=(val)
      @max = val.to_f
      if @max <= 0
        @max = nil
      elsif @max < @value
        @max = @value
      end
      redraw
    end

    def active? = @status.nil?
    def ok? = @status == :ok
    def failed? = @status == :failed

    def step(count: 1, title: nil)
      @title = title if title
      self.value += count
      self
    end

    def done(title = nil) = finish(:ok, title)
    alias ok done

    def failed(title = nil) = finish(:failed, title)

    alias _to_s to_s
    private :_to_s

    # @!visibility private
    def to_s
      return "#{title}: #{format('%5.2f', @value)}" unless @max
      "#{@title}: #{
        format(
          '%5.2f of %5.2f - %5.2f%%',
          @value,
          @max,
          100.0 * (@value / @max)
        )
      }"
    end

    # @!visibility private
    def inspect = "#{_to_s.chop} #{self}>"
  end

  class Progress
    include ProgressHelper

    private

    def finish(status, title)
      return if @status
      @status = status
      NattyUI.back_to_line(@pin_line)
      if status == :failed
        @parent.failed(title || @title)
      else
        cm = Theme.current.mark(:checkmark)
        @parent.puts(
          title || @title,
          pin: @pin,
          first_line_prefix: cm,
          first_line_prefix_width: cm.width
        )
      end
      self
    end

    def initialize(parent, title, max, pin)
      @parent = parent
      @value = 0.0
      @title = title
      @pin = pin
      @pin_line = NattyUI.lines_written
      @style = Theme.current.task_style
      max ? self.max = max : redraw
    end

    def redraw
      return if @status
      bar = @max ? bar(@value / @max) : moving_bar
      curr = bar ? [@title, bar] : [@title]
      return if @last == curr
      @pin_line = NattyUI.back_to_line(@pin_line) if @last
      @parent.puts(
        *curr,
        first_line_prefix: "#{@style}➔ ",
        first_line_prefix_width: 2
      )
      @last = curr
    end

    def moving_bar
      "#{@style}#{'·' * @value}" if @value >= 1
    end

    def bar(diff)
      size = [@parent.columns, 72].min - 11
      percent = format('%5.2f', 100.0 * diff)
      return percent if size < 10
      return if percent == '100.00'
      fill = '█' * (size * diff)
      "#{percent}% [bright_black]┃#{@style}#{fill}[bright_black]#{
        '░' * (size - fill.size)
      }┃[/]"
    end
  end

  class DumbProgress
    include ProgressHelper

    private

    def finish(status, title)
      return if @status
      @status = status
      if status == :failed
        @parent.failed(title || @title)
      else
        cm = Theme.current.mark(:checkmark)
        @parent.puts(
          title || @title,
          first_line_prefix: cm,
          first_line_prefix_width: cm.width
        )
      end
      self
    end

    def initialize(parent, title, max)
      @parent = parent
      @value = @last_value = 0.0
      @title = title
      max ? self.max = max : redraw
    end

    def redraw
      return if @status
      if @last_title != @title
        @parent.puts(
          @last_title = @title,
          first_line_prefix: '➔ ',
          first_line_prefix_width: 2
        )
      end
      return if @max.nil? || @value < 1
      percent = format('%3.0f %%', 100.0 * (@value / @max))
      return if @last_percent == percent
      @parent.puts(percent, first_line_prefix: '  ', first_line_prefix_width: 2)
      @last_percent = percent
    end
  end

  private_constant :Progress, :DumbProgress
end
