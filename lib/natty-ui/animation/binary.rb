# frozen_string_literal: true

module NattyUI
  module Animation
    class Binary < Base
      protected

      def write(stream)
        @style = attribute(:style, :default)
        @alt_style = attribute(:alt_style, :bright_white)
        binary = @lines.map { |_, size| Array.new(size) { rand_char } }
        35.times do |i|
          binary.each do |chars|
            rc = rand_char
            rc = @style + rc if rc.size == 1
            chars.pop
            chars.unshift(rc)
            puts(stream, chars.join)
          end
          (stream << @top).flush
          sleep(i / 300.0)
        end
        super
      end

      def rand_char
        return "#{@alt_style}#{CHARS.sample}#{@style}" if rand < 0.2
        CHARS.sample
      end

      CHARS = %w[0 1].freeze
    end

    define binary: Binary
    private_constant :Binary
  end
end
