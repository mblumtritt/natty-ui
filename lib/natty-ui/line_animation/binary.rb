# frozen_string_literal: true

module NattyUI
  module LineAnimation
    class Binary < None
      def initialize(*_)
        super
        @color = color
        @bright_color = attribute(:bright_color, :bright_white)
        @column = Ansi.cursor_column(@options[:prefix_width] + 1) + @color
      end

      def print(line)
        size = Text.width(line)
        10.times do
          (
            @stream << @column <<
              Array
                .new(size) do
                  if rand < 0.1
                    "#{@bright_color}#{CHARS.sample}#{@color}"
                  else
                    CHARS.sample
                  end
                end
                .join
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
