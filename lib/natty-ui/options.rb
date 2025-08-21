# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class Options < Element
    def select
      yield(self) if block_given?
      pin_line = NattyUI.lines_written
      draw
      last = @current
      while (event = Terminal.read_key_event)
        case event.name
        when 'Esc', 'Ctrl+c'
          return if @abortable
        when 'Enter'
          return @opts.transform_values(&:last)
        when 'Space'
          (last = @opts[@current])[-1] = !last[-1]
        when 'a'
          @opts.transform_values { _1[-1] = true }
          last = nil
        when 'n'
          @opts.transform_values { _1[-1] = false }
          last = nil
        when 'Home'
          @current = @opts.first.first
        when 'End'
          @current = @opts.keys.last
        when 'Up', 'Back', 'Shift+Tab', 'i'
          keys = @opts.keys
          @current = keys[keys.index(@current) - 1]
        when 'Down', 'Tab', 'k'
          keys = @opts.keys
          @current = keys[keys.index(@current) + 1] || keys[0]
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

    def initialize(parent, opts, abortable, selected)
      super(parent)
      @opts =
        opts.to_h do |k, v|
          v.is_a?(Enumerable) ? [k, [v[0], !!v[-1]]] : [k, [k, !!v]]
        end
      @abortable = abortable
      @current = @opts.key?(selected) ? selected : @opts.first.first
      @start_line = NattyUI.lines_written
      theme = Theme.current
      @style = {
        false => theme.choice_style,
        true => theme.choice_current_style
      }.compare_by_identity
    end

    def draw
      states = NattyUI::Theme.current.option_states
      @opts.each_pair do |key, (str, selected)|
        mark = states.dig(current = key == @current, selected)
        @parent.puts(
          "#{@style[current]}#{str}",
          first_line_prefix: mark,
          first_line_prefix_width: mark.width
        )
      end
    end
  end
  private_constant :Options
end
