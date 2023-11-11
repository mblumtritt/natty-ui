# frozen_string_literal: true

require_relative 'section'

module NattyUI
  module Features
    # Creates frame-enclosed section with a highlighted `title` and
    # prints given additional arguments as lines into the section.
    #
    # When no block is given, the section must be closed, see
    # {Wrapper::Element#close}.
    #
    # @param [#to_s] title object to print as section title
    # @param [Array<#to_s>] args more objects to print
    # @param [Symbol] type frame type;
    #   valid types are `:rounded`, `:simple`, `:heavy`, `:semi`, `:double`
    # @yieldparam [Wrapper::Framed] framed the created section
    # @return [Object] the result of the code block
    # @return [Wrapper::Framed] itself, when no code block is given
    def framed(title, *args, type: :rounded, &block)
      _section(self, :Framed, args, title: title, type: type, &block)
    end
  end

  class Wrapper
    #
    # A frame-enclosed {Section} with a highlighted title.
    #
    # @see Features#framed
    class Framed < Section
      protected

      def initialize(parent, title:, type:, **opts)
        top_start, top_suffix, left, bottom = components(type)
        parent.puts(" #{title} ", prefix: top_start, suffix: top_suffix)
        @bottom = bottom
        super(parent, prefix: "#{left} ", **opts)
      end

      def finish = parent.puts(@bottom)

      def components(type)
        COMPONENTS[type] || raise(ArgumentError, "invalid frame type - #{type}")
      end

      COMPONENTS = {
        rounded: %w[╭── ───── │ ╰──────────],
        simple: %w[┌── ───── │ └──────────],
        heavy: %w[┏━━ ━━━━━ ┃ ┗━━━━━━━━━━],
        semi: %w[┍━━ ━━━━━ │ ┕━━━━━━━━━━],
        double: %w[╔══ ═════ ║ ╚══════════]
      }.compare_by_identity.freeze
    end
  end
end
