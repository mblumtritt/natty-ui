# frozen_string_literal: true

module NattyUI
  module LineAnimation
    def self.defined = @defined.keys
    def self.defined?(name) = @defined.key?(name)
    def self.define(**kwargs) = @defined.merge!(kwargs)

    def self.[](name)
      return if name.nil?
      klass = @defined[name] || @defined[:default]
      return klass unless klass.is_a?(String)
      require(klass)
      klass = @defined[name] and return klass
      raise(LoadError, "unknown animation - #{name}")
    end

    class None
      def initialize(stream, options)
        @stream = stream
        @options = options
      end

      def print(_line) = raise(NotImplementedError)

      protected

      def to_column = Ansi.cursor_column(@options[:prefix_width] + 1)
      def color = attribute(:color, :default)

      def attribute(name, *default)
        att = @options[name] or return Ansi[*default]
        return Ansi[*att] if att.is_a?(Enumerable)
        Ansi.try_convert(att.to_s) || Ansi[*default]
      end

      SPACE = /[[:space:]]/
    end
    private_constant :None

    dir = __dir__
    @defined = {
      default: "#{dir}/line_animation/default",
      matrix: "#{dir}/line_animation/matrix",
      rainbow: "#{dir}/line_animation/rainbow",
      type_writer: "#{dir}/line_animation/type_writer"
    }.compare_by_identity
  end
end
