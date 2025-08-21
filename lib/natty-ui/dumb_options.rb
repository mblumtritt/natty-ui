# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class DumbOptions < Element
    def select
      yield(self) if block_given?
      draw
      while (event = Terminal.read_key_event)
        return if @abortable && %w[Esc Ctrl+c].include?(event.name)
        return @opts.transform_values(&:last) if event.name == 'Enter'
        next unless event.simple?
        code = event.raw.upcase
        if @opts.size <= 9
          next unless ('1'..'9').include?(code)
          offset = 49
        elsif ('A'..'Z').include?(code)
          offset = 65
        else
          next
        end
        key = @opts.keys[code.ord - offset] or next
        @opts[key][-1] = !@opts[key][-1]
        @parent.space
        draw
      end
    ensure
      @parent.space
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
      theme = Theme.current
      @marks = {
        true => theme.mark(:checkmark),
        false => theme.mark(:choice)
      }.compare_by_identity
    end

    def draw
      glyph = @opts.size <= 9 ? 1 : 'A'
      @opts.each_pair do |_, (str, selected)|
        mark = @marks[selected]
        @parent.puts(
          str,
          first_line_prefix: "[\\#{glyph}] #{mark}",
          first_line_prefix_width: mark.width + 2
        )
        glyph = glyph.succ
      end
    end
  end
  private_constant :DumbOptions
end
