# frozen_string_literal: true

module NattyUI
  # Helper class to select spinner types.
  # @see Features#progress
  module Spinner
    # Defined spinner type names.
    # @see []
    #
    # @attribute [r] self.names
    # @return [Array<Symbol>] supported attribute names
    def self.names = @all.keys

    # @param name [Symbol, #to_a, #to_s]
    #   defined type name (see {.names})
    #   or spinner elements
    # @return [Enumerator] spinner definition
    def self.[](name)
      return @default if name == :default
      if name.is_a?(Symbol)
        name = @all[name] or
          raise(ArgumentError, "invalid spinner type - #{name}")
      end
      name = name.respond_to?(:to_a) ? name.to_a : name.to_s.chars
      name = name.zip(name).flatten(1) while name.size < 6
      Enumerator.new { |y| name.each { y << "#{@style}#{_1}" } while true }
    end

    # Define spinner type used by default.
    # @attribute [w] self.default
    # @param value [Symbol] type name
    # @return [Symbol] type name
    def self.default=(value)
      @default = self[value.nil? || value == :default ? :pulse : value]
    end

    @style = Ansi[:bold, 220]
    @all = {
      bar: '▁▂▃▄▅▆▇█▇▆▅▄▃▂',
      blink: '■□▪▫',
      blocks: '▖▘▝▗',
      bounce: [
        '[    ]',
        '[=   ]',
        '[==  ]',
        '[=== ]',
        '[ ===]',
        '[  ==]',
        '[   =]',
        '[    ]',
        '[   =]',
        '[  ==]',
        '[ ===]',
        '[====]',
        '[=== ]',
        '[==  ]',
        '[=   ]'
      ],
      circle: '◐◓◑◒',
      colors: '🟨🟧🟧🟥🟥🟦🟦🟪🟪🟩🟩',
      dot_scroll: ['.  ', '.. ', '...', ' ..', '  .', '   '],
      dots: '⣷⣯⣟⡿⢿⣻⣽⣾',
      dots2: '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏',
      dots3: '⠋⠙⠚⠞⠖⠦⠴⠲⠳⠓',
      dots4: '⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆',
      dots5: '⠋⠙⠚⠒⠂⠂⠒⠲⠴⠦⠖⠒⠐⠐⠒⠓⠋',
      pingpong: [
        '(●     )',
        '( ●    )',
        '(  ●   )',
        '(   ●  )',
        '(    ● )',
        '(     ●)',
        '(    ● )',
        '(   ●  )',
        '(  ●   )',
        '( ●    )'
      ],
      pulse: '•✺◉●◉✺',
      slide: %w[
        ▰▱▱▱▱▱▱
        ▰▰▱▱▱▱▱
        ▰▰▰▱▱▱▱
        ▰▰▰▰▱▱▱
        ▰▰▰▰▰▱▱
        ▰▰▰▰▰▰▱
        ▰▰▰▰▰▰▰
        ▱▰▰▰▰▰▰
        ▱▱▰▰▰▰▰
        ▱▱▱▰▰▰▰
        ▱▱▱▱▰▰▰
        ▱▱▱▱▱▰▰
        ▱▱▱▱▱▱▰
        ▱▱▱▱▱▱▱
      ],
      slide2: [
        '◍ ◌ ◌ ◌ ◌ ◌ ◌',
        '◍ ◍ ◌ ◌ ◌ ◌ ◌',
        '◍ ◍ ◍ ◌ ◌ ◌ ◌',
        '◍ ◍ ◍ ◍ ◌ ◌ ◌',
        '◍ ◍ ◍ ◍ ◍ ◌ ◌',
        '◍ ◍ ◍ ◍ ◍ ◍ ◌',
        '◍ ◍ ◍ ◍ ◍ ◍ ◍',
        '◌ ◍ ◍ ◍ ◍ ◍ ◍',
        '◌ ◌ ◍ ◍ ◍ ◍ ◍',
        '◌ ◌ ◌ ◍ ◍ ◍ ◍',
        '◌ ◌ ◌ ◌ ◍ ◍ ◍',
        '◌ ◌ ◌ ◌ ◌ ◍ ◍',
        '◌ ◌ ◌ ◌ ◌ ◌ ◍',
        '◌ ◌ ◌ ◌ ◌ ◌ ◌'
      ],
      snake: '⠁⠉⠙⠸⢰⣠⣄⡆⠇⠃',
      stod: '⡿⣟⣯⣷⣾⣽⣻⢿',
      swap: '㊂㊀㊁',
      vintage: '-\\|/'
    }.compare_by_identity

    self.default = nil
  end
end
