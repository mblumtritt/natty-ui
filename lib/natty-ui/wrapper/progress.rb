# frozen_string_literal: true

require_relative 'element'
require_relative 'mixins'

module NattyUI
  module Features
    # Creates progress element implementing additional {ProgressAttributes}.
    #
    # When a `max_value` is given, the progress will by displayed as a bar.
    # Otherwise the `spinner` is used for a little animation.
    #
    # When no pre-defined spinner is specified then spinner will be
    # used char-wise as a string for the progress animation.
    #
    # A progress element has additional states and can be closed with
    # {#completed} or {#failed}.
    #
    # @param [#to_s] title object to print as progress title
    # @param [#to_f] max_value maximum value of the progress
    # @param [:bar, :blink, :blocks, :braile, :circle, :colors, :pulse,
    #   :snake, :swap, :triangles, :vintage, #to_s] spinner type of spinner or
    #   spinner elements
    # @return [Wrapper::Progress] the created progress element
    def progress(title, max_value: nil, spinner: :pulse)
      _element(:Progress, title, max_value, spinner)
    end
  end

  class Wrapper
    #
    # An {Element} displaying a progression.
    #
    # @see Features#progress
    class Progress < Element
      include ProgressAttributes
      include ValueAttributes

      protected

      def call(title, max_value, spinner)
        @final_text = [title]
        @max_value = [0, max_value.to_f].max if max_value
        @value = @progress = 0
        draw(title, SPINNER[spinner] || spinner.to_s)
        self
      end

      SPINNER = {
        bar: '▁▂▃▄▅▆▇█▇▆▅▄▃▂',
        blink: '■□▪▫',
        blocks: '▖▘▝▗',
        braile: '⣷⣯⣟⡿⢿⣻⣽⣾',
        braile_reverse: '⡿⣟⣯⣷⣾⣽⣻⢿',
        circle: '◐◓◑◒',
        colors: '🟨🟧🟥🟦🟪🟩',
        pulse: '•✺◉●◉✺',
        snake: '⠁⠉⠙⠸⢰⣠⣄⡆⠇⠃',
        swap: '㊂㊀㊁',
        triangles: '◢◣◤◥',
        vintage: '-\\|/'
      }.compare_by_identity.freeze
      private_constant :SPINNER

      def draw(title, _spinner)
        (wrapper.stream << @parent.prefix << "➔ #{title} ").flush
      end

      def end_draw = (wrapper.stream << "\n")

      def redraw
        return (wrapper.stream << '.').flush unless @max_value
        cn = (20 * @value / @max_value).to_i
        return if @progress == cn
        (wrapper.stream << ('.' * (cn - @progress))).flush
        @progress = cn
      end

      def finish
        end_draw
        return @parent.failed(*@final_text) if failed?
        _section(
          :Message,
          @final_text,
          owner: @parent,
          title: @final_text.shift,
          glyph: @status = :completed
        )
      end
    end
  end
end
