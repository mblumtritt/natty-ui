# frozen_string_literal: true

module NattyUI
  module Animation
    def self.names = @all.keys

    def self.[](name)
      return if name.nil?
      klass = @all[name] || @all[:default]
      return klass unless klass.is_a?(String)
      require(klass)
      klass = @all[name] and return klass
      raise(LoadError, "unknown animation - #{name}")
    end

    def self.define(**kwargs) = @all.merge!(kwargs)

    class Base
      attr_reader :lines_written

      def initialize(wrapper, args, kwargs)
        @prefix = Text.embellish(kwargs[:prefix])
        @suffix = Text.embellish(kwargs[:suffix])
        @prefix_width = kwargs[:prefix_width] || Text.width(@prefix)
        @lines =
          Text.as_lines(
            args.map! { Ansi.blemish(_1) },
            kwargs[:max_width] ||
              wrapper.screen_columns - @prefix_width -
                (kwargs[:suffix_width] || Text.width(@suffix))
          )
        diff = @lines.size - wrapper.screen_rows + 1
        @lines = @lines[diff, wrapper.screen_rows] if diff.positive?
        @options = kwargs
        @prefix_width += 1
        @top = Ansi.cursor_up(@lines_written = @lines.count)
        @pos1 = Ansi.cursor_column(@prefix_width)
      end

      def perform(stream)
        @lines.each { stream << "#{@prefix}#{' ' * _2}#{@suffix}\n" }
        stream << @top
        write(stream)
      end

      protected

      def attribute(name, *default)
        att = @options[name] or return Ansi[*default]
        return Ansi[*att] if att.is_a?(Enumerable)
        Ansi.try_convert(att.to_s) || Ansi[*default]
      end

      def write(stream) = @lines.each { |line, _| puts(stream, line) }
      def puts(stream, line) = stream << @pos1 << line << Ansi::LINE_NEXT
    end

    private_constant :Base

    dir = __dir__
    @all = {
      binary: "#{dir}/animation/binary",
      default: "#{dir}/animation/default",
      matrix: "#{dir}/animation/matrix",
      rainbow: "#{dir}/animation/rainbow",
      type_writer: "#{dir}/animation/type_writer"
    }.compare_by_identity
  end
end
