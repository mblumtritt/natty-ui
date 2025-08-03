# frozen_string_literal: true

require 'terminal'
require_relative 'natty-ui/features'

# This is the beautiful, nice, nifty, fancy, neat, pretty, cool, rich, lovely,
# natty user interface you like to have for your command line applications.
#
# The {NattyUI} ​ᓚᕠᗢ main module implements all {Features}.
#
module NattyUI
  # Uses the ANSI tools of the Terminal.rb gem
  Ansi = Terminal::Ansi

  # Uses the Text tools of the Terminal.rb gem
  Text = Terminal::Text

  extend Features

  class << self
    # Current used {Element} (or {NattyUI} as top element) supporting all
    # {Features}.
    #
    # @return [Features]
    #   current element or itself
    attr_reader :element

    # Supported input mode.
    #
    # @attribute [r] input_mode
    # @return [:default]
    #   when terminal uses ANSI
    # @return [:dumb]
    #   when terminal does not support ANSI or interactive input
    # @return [nil]
    #   when terminal inoput is not supported
    def input_mode
      case Terminal.input_mode
      when :csi_u
        :default
      when :legacy
        Terminal.ansi? ? :default : :dumb
      when :dumb
        :dumb
      end
    end

    # Terminal title.
    #
    # @attribute [r] title
    # @return [String]
    #   configured title
    # @return [nil]
    #   when no title was set
    def title = @title_stack.last

    # @attribute [w] title
    def title=(value)
      if value
        title = Ansi.plain(value).gsub(/\s+/, ' ')
        _write(Ansi.title(title)) if Terminal.ansi?
        @title_stack << title
      else
        @title_stack.pop
        last = @title_stack[-1]
        _write(Ansi.title(last)) if last && Terminal.ansi?
      end
    end

    # @!visibility private
    attr_reader :lines_written

    # @!visibility private
    def back_to_line(number, erase: true)
      return @lines_written if (c = @lines_written - number) <= 0
      if Terminal.ansi?
        _write(
          if erase == :all
            Ansi.cursor_prev_line(c) + Ansi::SCREEN_ERASE_BELOW
          else
            erase ? (Ansi::LINE_ERASE_PREV * c) : Ansi.cursor_prev_line(c)
          end
        )
      end
      @lines_written = number
    end

    # @!visibility private
    def alternate_screen
      return yield unless Terminal.ansi?
      begin
        _write(Ansi::SCREEN_ALTERNATE)
        yield
      ensure
        _write(Ansi::SCREEN_ALTERNATE_OFF)
      end
    end

    private

    def _write(str) = Terminal.__send__(:_write, str)

    def with(element)
      Terminal.hide_cursor if @element == self
      current, @element = @element, element
      yield(element) if block_given?
    ensure
      element.done if element.respond_to?(:done)
      Terminal.show_cursor if (@element = current) == self
    end
  end

  @element = self
  @lines_written = 0
  @title_stack = []
end

unless defined?(Kernel.ui)
  module Kernel
    # @attribute [r] ui
    # @return [NattyUI::Features] current used ui element
    # @see NattyUI.element
    def ui = NattyUI.element

    # alias ​ᓚᕠᗢ ui
  end
end
