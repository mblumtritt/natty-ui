# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Ask a yes/no question from user.
    #
    # The defaults for `yes` and `no` will work for
    # Afrikaans, Dutch, English, French, German, Italian, Polish, Portuguese,
    # Romanian, Spanish and Swedish.
    #
    # The default for `yes` includes `ENTER` and `RETURN` key
    #
    # @example
    #   case ui.ask('Do you like the NattyUI gem?')
    #   when true
    #     ui.info('Yeah!!')
    #   when false
    #     ui.write("That's pity!")
    #   else
    #     ui.failed('You should have an opinion!')
    #   end
    #
    # @see NattyUI.in_stream
    #
    # @param question [#to_s] Question to display
    # @param yes [#to_s] chars which will be used to answer 'Yes'
    # @param no [#to_s] chars which will be used to answer 'No'
    # @return [Boolean] whether the answer is yes or no
    # @return [nil] when input was aborted with `^C` or `^D`
    def ask(question, yes: "jotsyd\r\n", no: 'n')
      _element(:Ask, question, yes, no)
    end
  end

  class Wrapper
    #
    # An {Element} to ask user input for yes/no queries.
    #
    # @see Features#ask
    class Ask < Element
      protected

      def call(question, yes, no)
        yes, no = grab(yes, no)
        draw(question)
        while true
          char = NattyUI.in_stream.getch
          return if "\3\4".include?(char)
          return true if yes.include?(char)
          return false if no.include?(char)
        end
      rescue Interrupt, SystemCallError
        nil
      ensure
        if @parent.ansi?
          (wrapper.stream << Ansi::LINE_CLEAR).flush
        else
          @parent.puts
        end
      end

      def draw(question)
        glyph = wrapper.glyph(:query)
        @parent.print(
          question,
          prefix: "#{glyph} #{Ansi[255]}",
          prefix_width: NattyUI.display_width(glyph) + 1,
          suffix_width: 0
        )
      end

      def grab(yes, no)
        yes = yes.to_s.chars.uniq
        raise(ArgumentError, ':yes can not be empty') if yes.empty?
        no = no.to_s.chars.uniq
        raise(ArgumentError, ':no can not be empty') if no.empty?
        return yes, no if (yes & no).empty?
        raise(ArgumentError, 'chars in :yes and :no can not be intersect')
      end
    end
  end
end
