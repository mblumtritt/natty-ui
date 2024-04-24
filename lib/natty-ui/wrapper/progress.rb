# frozen_string_literal: true

require_relative 'element'
require_relative 'mixins'

module NattyUI
  module Features
    # Creates progress element implementing additional {ProgressAttributes}.
    #
    # A progress element has additional states and can be closed with {#completed}
    # or {#failed}.
    #
    # @param [#to_s] title object to print as progress title
    # @param [##to_f] max_value maximum value of the progress
    # @return [Wrapper::Progress] the created progress element
    def progress(title, max_value: nil)
      _element(:Progress, title, max_value)
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

      def call(title, max_value)
        @final_text = [title]
        @max_value = [0, max_value.to_f].max if max_value
        @value = @progress = 0
        draw(title)
        self
      end

      def draw(title)
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
