# frozen_string_literal: true

require_relative 'element'

module NattyUI
  # {Element} implemting a task display section used by {Features.task}.
  #
  class Task < Temporary
    include StateMixin

    private

    def finish_ok(text)
      NattyUI.back_to_line(@start_line)
      @start_line = nil
      cm = Theme.current.mark(:checkmark)
      text << @title if text.empty?
      @parent.puts(
        *text,
        first_line_prefix: cm,
        first_line_prefix_width: cm.width,
        pin: @pin
      )
      super()
    end

    def initialize(parent, title, msg, pin)
      super(parent)
      @title = title
      @prefix = '  '
      @prefix_width = 2
      @pin = pin
      style = Theme.current.task_style
      parent.puts(
        title,
        first_line_prefix: "#{style}➔ ",
        first_line_prefix_width: 2,
        prefix: "#{style}  ",
        prefix_width: 2
      )
      puts(*msg) unless msg.empty?
    end
  end
end
