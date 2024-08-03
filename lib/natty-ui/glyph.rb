# frozen_string_literal: true

module NattyUI
  # Helper class to select glyph types.
  # @see Features#message
  module Glyph
    # Define glyph type used by default.
    # @attribute [w] self.default
    # @param value [Symbol] type name
    # @return [Symbol] type name
    def self.default=(value)
      @default = self[value.nil? || value == :default ? :point : value]
    end

    # Defined glyph type names.
    # @see []
    #
    # @attribute [r] self.names
    # @return [Array<Symbol>] supported attribute names
    def self.names = @all.keys

    # @param name [Symbol, #to_s]
    #   defined type name (see {.names})
    #   or glyph
    # @return [String] glyph definition
    def self.[](name)
      return @default if name == :default
      Text.embellish(
        if name.is_a?(Symbol)
          @all[name] or raise(ArgumentError, "invalid glyph type - #{name}")
        else
          name.to_s
        end
      )
    end

    @all = {
      completed: '[b 52]✓',
      dot: '[27]•',
      error: '[b d0]𝙓',
      failed: '[b c4]𝑭',
      information: '[b 77]𝒊',
      point: '[27]◉',
      query: '[b 27]▸',
      task: '[b 27]➔',
      warning: '[b dd]!'
    }.compare_by_identity

    # GLYPH = {
    #   default: '●',
    #   information: '🅸 ',
    #   warning: '🆆 ',
    #   error: '🅴 ',
    #   completed: '✓',
    #   failed: '🅵 ',
    #   task: '➔',
    #   query: '🆀 '
    # }.compare_by_identity.freeze

    self.default = nil
  end
end
