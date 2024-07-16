# frozen_string_literal: true

module NattyUI
  module LineAnimation
    class Rainbow < None
      def initialize(*_)
        super
        @prefix = to_column
      end

      def print(line)
        line = Text.plain(line)
        11.upto(150) do |spread|
          (
            @stream << @prefix <<
              Ansi.rainbow(
                line,
                spread: spread / 100.0,
                frequence: 0.1,
                seed: 0
              )
          ).flush
          sleep(0.01)
        end
      end
    end

    define rainbow: Rainbow
    private_constant :Rainbow
  end
end
