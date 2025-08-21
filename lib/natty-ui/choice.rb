# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class Choice < Element
    def select
      yield(self) if block_given?
      pin_line = NattyUI.lines_written
      draw
      last = @current
      while (event = Terminal.read_key_event)
        case event.name
        when 'Esc', 'Ctrl+c'
          break nil if @abortable
        when 'Enter', 'Space'
          break @ret[@current]
        when 'Home'
          @current = 0
        when 'End'
          @current = @texts.size - 1
        when 'Up', 'Back', 'Shift+Tab', 'i', 'w'
          @current = @texts.size - 1 if (@current -= 1) < 0
        when 'Down', 'Tab', 'k', 's'
          @current = 0 if (@current += 1) == @texts.size
        else
          next unless event.simple?
          c = event.key.ord
          @current = (c - 48).clamp(0, @texts.size - 1) if c.between?(48, 57)
        end
        next if last == @current
        pin_line = NattyUI.back_to_line(pin_line, erase: false)
        draw
        last = @current
      end
    ensure
      NattyUI.back_to_line(@start_line)
    end

    private

    def initialize(parent, args, kwargs, abortable, selected)
      super(parent)
      @start_line = NattyUI.lines_written
      @texts = args + kwargs.values
      @ret = Array.new(args.size, &:itself) + kwargs.keys
      @abortable = abortable
      @current = @ret.index(selected) || 0
      theme = Theme.current
      @mark = [theme.mark(:choice), theme.choice_style]
      @mark_current = [theme.mark(:current_choice), theme.choice_current_style]
    end

    def draw
      @texts.each_with_index do |str, idx|
        mark, style = idx == @current ? @mark_current : @mark
        @parent.puts(
          "#{style}#{str}",
          first_line_prefix: mark,
          first_line_prefix_width: mark.width
        )
      end
    end
  end
  private_constant :Choice
end
