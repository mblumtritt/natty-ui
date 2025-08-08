# frozen_string_literal: true

require_relative 'element'

module NattyUI
  # Task display section used by {Features.task}.
  #
  class Task < Temporary
    include WithStatus

    private

    def _done(text)
      NattyUI.back_to_line(@start_line, erase: :all)
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
      @prefix = '  '
      @prefix_width = 2
      @pin = pin
      style = Theme.current.task_style
      cm = Theme.current.mark(:current)
      cmw = cm.width + 1
      parent.puts(
        title,
        first_line_prefix: "#{cm} #{style}",
        first_line_prefix_width: cmw,
        prefix: "#{style}#{' ' * cmw}",
        prefix_width: cmw
      )
      puts(*msg) unless msg.empty?
    end
  end
end
