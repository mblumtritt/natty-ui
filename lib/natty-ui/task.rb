# frozen_string_literal: true

require_relative 'element'

module NattyUI
  # Task display section used by {Features.task}.
  #
  class Task < Temporary
    include WithStatus

    private

    def _done(text)
      NattyUI.back_to_line(@start_line)
      @start_line = nil
      cm = Theme.current.mark(:checkmark)
      @parent.puts(
        *text,
        first_line_prefix: cm,
        first_line_prefix_width: cm.width,
        pin: @pin
      )
      @pins&.each { |objects, options| puts(*objects, **options) }
    end

    def _failed
      @start_line = nil
    end

    def initialize(parent, title, msg, pin)
      super(parent)
      @title = title
      @pin = pin
      style = Theme.current.task_style
      cm = Theme.current.mark(:current)
      @prefix = ' ' * cm.width
      @prefix_width = cm.width
      parent.puts(
        title,
        first_line_prefix: "#{cm}#{style}",
        first_line_prefix_width: cm.width,
        prefix: "#{@prefix}#{style}",
        prefix_width: cm.width
      )
      puts(*msg) unless msg.empty?
    end
  end
end
