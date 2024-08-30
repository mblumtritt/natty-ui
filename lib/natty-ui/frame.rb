# frozen_string_literal: true

module NattyUI
  # Helper class to select frame types.
  #
  # @see Features#columns
  # @see Features#framed
  # @see Features#table
  # @see Features::Cell#frame
  # @see Features::Columns#frame
  module Frame
    # Define frame type used by default.
    #
    # @attribute [w] self.default
    # @param value [Symbol] type name
    # @return [Symbol] type name
    def self.default=(value)
      @default = self[value.nil? || value == :default ? :rounded : value]
    end

    # Defined frame type names.
    # Default values: `:double`, `:heavy`, `:rounded`, `:semi`, `:semi2`,
    # `:simple`
    #
    # @see []
    #
    # @attribute [r] self.names
    # @return [Array<Symbol>] supported attribute names
    def self.names = @ll.keys

    # @param name [Symbol, String]
    #   defined type name (see {.names})
    #   or frame elements
    # @return [String] frame definition
    def self.[](name)
      return @default if name == :default
      if name.is_a?(Symbol)
        ret = @ll[name] and return ret
      elsif name.is_a?(String)
        return name if name.empty? || name.size == 11
        return name * 11 if name.size == 1
      end
      raise(ArgumentError, "invalid frame type - #{name}")
    end

    @ll = {
      cols: '    │ │    ',
      double: '╔╗╚╝║═╬╦╩╠╣',
      heavy: '┏┓┗┛┃━╋┳┻┣┫',
      rounded: '╭╮╰╯│─┼┬┴├┤',
      rows: '     ──    ',
      semi: '╒╕╘╛│═╪╤╧╞╡',
      semi2: '╓╖╙╜║─╫╥╨╟╢',
      simple: '┌┐└┘│─┼┬┴├┤',
      undecorated: '           '
    }.compare_by_identity

    self.default = nil
  end
end
