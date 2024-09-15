# frozen_string_literal: true

module NattyUI
  module Animation
    class Rainbow < Base
      protected

      def write(stream)
        plain = @lines.map { |line, _| Ansi.plain(line) }
        11.upto(180) do |spread|
          spread /= 100.0
          plain.each do |line|
            puts(
              stream,
              Ansi.rainbow(line, spread: spread, frequence: 0.1, seed: 0)
            )
          end
          (stream << Ansi::RESET << @top).flush
          sleep(0.01)
        end
        super
      end
    end

    define rainbow: Rainbow
    private_constant :Rainbow
  end
end
