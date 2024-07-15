# frozen_string_literal: true

module NattyUI
  module LineAnimation
    class Binary < None
      def initialize(*_)
        super
        @column = Ansi.cursor_column(@options[:prefix_width] + 1)
        @color = color
      end

      def print(line)
        line = Text.plain(line)
        @stream << @color
        10.times do
          (
            @stream << @column << Array.new(line.size) { CHARS.sample }.join
          ).flush
          sleep(0.08)
        end
      end

      CHARS = %w[0 1].freeze
    end

    define binary: Binary
    private_constant :Binary
  end
end
