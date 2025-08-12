# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class Choice < Element
    def select
      yield(self) if block_given?
      pin_line = NattyUI.lines_written
      draw(current = @ret.index(@selected) || 0)
      while (key = Terminal.read_key)
        case key
        when 'Esc', 'Ctrl+c'
          break nil if @abortable
        when 'Enter', ' '
          break @ret[current]
        when 'Up', 'Left', 'Back', 'Shift+Tab'
          current = @texts.size - 1 if (current -= 1) < 0
          pin_line = NattyUI.back_to_line(pin_line, erase: false)
          draw(current)
        when 'Down', 'Right', 'Tab'
          current = 0 if (current += 1) == @texts.size
          pin_line = NattyUI.back_to_line(pin_line, erase: false)
          draw(current)
        end
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
      @selected = selected
      theme = Theme.current
      @mark = [theme.mark(:choice), theme.choice_style]
      @mark_current = [theme.mark(:current_choice), theme.choice_current_style]
    end

    def draw(current)
      @texts.each_with_index do |str, idx|
        mark, decor = idx == current ? @mark_current : @mark
        @parent.puts(
          "#{decor}#{str}",
          first_line_prefix: mark,
          first_line_prefix_width: mark.width
        )
      end
    end
  end
  private_constant :Choice
end
