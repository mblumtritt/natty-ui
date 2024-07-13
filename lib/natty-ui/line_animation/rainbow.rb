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
        11.upto(200) do |spread|
          (
            @stream << @prefix <<
              Ansi.rainbow(
                line,
                frequence: 0.1,
                spread: spread / 100.0,
                seed: 0
              )
          ).flush
          sleep(0.01)
        end
      end
    end

    define rainbow: Rainbow
  end
end
