# frozen_string_literal: true

require_relative 'element'

module NattyUI
  # {Element} with a frame around the content used by {Features.framed}.
  #
  class Framed < Element
    # @!visibility private
    def closed? = @bottom ? false : true

    # @!visibility private
    def puts(*objects, **options)
      return self if closed?
      options[:align] = @align
      options[:expand] = true
      super
    end

    # @!visibility private
    def done
      return if closed?
      @parent.puts(@bottom)
      @bottom = nil
    end

    # @!visibility private
    def inspect = "#{_to_s.chop} align=#{@align.inspect} closed?=#{closed?}>"

    private

    def initialize(parent, align, chars, style, msg)
      super(parent)
      @align = align
      if style
        style = Ansi[*style]
        @prefix = "#{style}#{chars[9]}[/] "
        @suffix = " #{style}#{chars[9]}[/]"
      else
        @prefix = "#{chars[9]} "
        @suffix = " #{chars[9]}"
      end
      @prefix_width = 2
      @suffix_width = 2
      line = chars[10] * (parent.columns - 2)
      parent.puts("#{style}#{chars[0]}#{line}#{chars[2]}")
      @bottom = "#{style}#{chars[6]}#{line}#{chars[8]}"
      puts(*msg) unless msg.empty?
    end
  end
end
