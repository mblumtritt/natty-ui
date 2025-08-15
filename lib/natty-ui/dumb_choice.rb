# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class DumbChoice < Element
    def select
      yield(self) if block_given?
      draw
      while (event = Terminal.read_key_event)
        return if @abortable && %w[Esc Ctrl+c].include?(event.name)
        next unless event.simple?
        code = event.raw.upcase
        if @ret.size <= 9 && ('1'..'9').include?(code)
          code = @ret[code.ord - 49] and break code
        elsif ('A'..'Z').include?(code)
          code = @ret[code.ord - 65] and break code
        end
      end
    end

    private

    def draw
      glyph = @ret.size <= 9 ? 1 : 'A'
      @texts.each do |str|
        @parent.puts(
          str,
          first_line_prefix: "[\\#{glyph}] ",
          first_line_prefix_width: 4
        )
        glyph = glyph.succ
      end
      @texts = nil
    end

    def initialize(parent, args, kwargs, abortable)
      super(parent)
      @ret = Array.new(args.size, &:itself) + kwargs.keys
      @texts = args + kwargs.values
      @abortable = abortable
    end
  end
  private_constant :DumbChoice
end
