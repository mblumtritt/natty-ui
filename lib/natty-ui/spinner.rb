# frozen_string_literal: true

require_relative 'ansi'

module NattyUI
  # Helper class to select spinner types.
  #
  # @see Features#progress
  module Spinner
    class << self
      # Define spinner type used by default.
      # @attribute [w] self.default
      # @param value [Symbol] type name
      # @return [Symbol] type name
      def default=(value)
        @default = self[value.nil? || value == :default ? :pulse : value]
      end

      # Defined spinner type names.
      # Default values: `:bar`, `:blink`, `:blocks`, `:bounce`, `:bounce2`,
      # `:bounce3`, `:bounce4`, `:circle`, `:colors`, `:dots`, `:dots2`,
      # `:dots3`, `:dots4`, `:dots5`, `:move`, `:move2`, `:move3`, `:move4`,
      # `:pulse`, `:slide`, `:slide2`, `:slide3`, `:slide4`, `:slide5`,
      # `:snake`, `:stod`, `:swap`, `:vintage`
      #
      # @see []
      #
      # @attribute [r] self.names
      # @return [Array<Symbol>] supported attribute names
      def names = @ll.keys

      # @param name [Symbol, #to_a, #to_s]
      #   defined type name (see {.names})
      #   or spinner elements
      # @return [Enumerator] spinner definition
      def [](name)
        return @default if name == :default
        parts =
          if name.is_a?(Symbol)
            @ll[name] or raise(ArgumentError, "invalid spinner type - #{name}")
          else
            name
          end
        parts =
          (parts.respond_to?(:map) ? parts : parts.to_s.chars).map do |part|
            "#{@style}#{part}#{Ansi::RESET}"
          end
        raise(ArgumentError, "invalid spinner type - #{name}") if parts.empty?
        parts = parts.zip(parts).flatten(1) while parts.size < 6
        Enumerator.new { |y| parts.each { y << _1 } while true }
      end

      private

      def slide(a, b, size, prefix = nil, suffix = prefix)
        Enumerator.new do |y|
          fn =
            lambda do |i|
              y << "#{prefix}#{a * (i += 1)}#{b * (size - i)}#{suffix}"
            end
          size.times(&fn)
          a, b = b, a
          size.times(&fn)
        end
      end

      def bounce(a, b, size, prefix = nil, suffix = prefix)
        Enumerator.new do |y|
          fn =
            lambda do |i|
              y << "#{prefix}#{a * (i += 1)}#{b * (size - i)}#{suffix}"
            end
          size.times(&fn)
          a, b = b, a
          (size - 1).times(&fn)
          fn = ->(i) { y << "#{prefix}#{a * i}#{b * (size - i)}#{suffix}" }
          (size - 2).downto(0, &fn)
          a, b = b, a
          (size - 1).downto(0, &fn)
        end
      end

      def move(a, b, size, prefix = nil, suffix = prefix)
        Enumerator.new do |y|
          size.times do |i|
            y << "#{prefix}#{b * i}#{a}#{b * (size - i - 1)}#{suffix}"
          end
          y << "#{prefix}#{b * size}#{suffix}"
        end
      end
    end

    @style = Ansi[:bold, 220]
    @ll = {
      bar: '▁▂▃▄▅▆▇█▇▆▅▄▃▂',
      blink: '■□▪▫',
      blocks: '▖▘▝▗',
      bounce: bounce('◼︎', '◻︎', 7),
      bounce2: bounce('▰', '▱', 7),
      bounce3: bounce('● ', '◌ ', 7),
      bounce4: bounce('=', ' ', 5, '[', ']'),
      circle: '◐◓◑◒',
      colors: '🟨🟨🟧🟧🟥🟥🟦🟦🟪🟪🟩🟩',
      dots: '⣷⣯⣟⡿⢿⣻⣽⣾',
      dots2: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏',
      dots3: '⠋⠙⠚⠞⠖⠦⠴⠲⠳⠓',
      dots4: '⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆',
      dots5: '⠋⠙⠚⠒⠂⠂⠒⠲⠴⠦⠖⠒⠐⠐⠒⠓⠋',
      move: move('◼︎', '◻︎', 7),
      move2: move('▰', '▱', 7),
      move3: move('● ', '◌ ', 7),
      move4: move('=', ' ', 5, '[', ']'),
      pulse: '•✺◉●◉✺',
      slide: slide('◼︎', '◻︎', 7),
      slide2: slide('▰', '▱', 7),
      slide3: slide('● ', '◌ ', 7),
      slide4: slide('=', ' ', 5, '[', ']'),
      slide5: slide('.', ' ', 3),
      snake: '⠁⠉⠙⠸⢰⣠⣄⡆⠇⠃',
      stod: '⡿⣟⣯⣷⣾⣽⣻⢿',
      swap: '㊂㊀㊁',
      vintage: '-\\|/'
    }.compare_by_identity

    self.default = nil
  end
end
