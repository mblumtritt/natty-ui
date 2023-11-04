# frozen_string_literal: true

module NattyUI
  class Wrapper
    #
    # Mix-in for output functionality.
    #
    module Features
      # @!group Instance Methods To Create Sections

      # Creates a default section and prints given arguments as lines
      # into the section.
      #
      # @param [Array<#to_s>] args objects to print
      # @yieldparam [Section] section the created section
      # @return [Object] the result of the code block
      # @return [Section] itself, when no code block is given
      def section(*args, &block)
        _section(:Section, args, prefix: '  ', suffix: '  ', &block)
      end
      alias sec section

      # Creates a quotation section and prints given arguments as lines
      # into the section.
      #
      # @param (see #section)
      # @yieldparam (see #section)
      # @return (see #section)
      def quote(*args, &block)
        _section(:Section, args, prefix: '▍ ', prefix_attr: 39, &block)
      end

      # Creates a simple message section with a highlighted `title`  and
      # prints given additional arguments as lines into the section.
      #
      # @param [#to_s] title object to print as section title
      # @param [Array<#to_s>] args more objects to print
      # @param [#to_s] symbol symbol/prefix used for the title
      # @yieldparam (see #section)
      # @return (see #section)
      def message(title, *args, symbol: '•', &block)
        _section(:Message, args, title: title, symbol: symbol, &block)
      end
      alias msg message

      # Creates a informational message section with a highlighted `title`  and
      # prints given additional arguments as lines into the section.
      #
      # @param [#to_s] title object to print as section title
      # @param [Array<#to_s>] args more objects to print
      # @yieldparam (see #section)
      # @return (see #section)
      def information(title, *args, &block)
        _section(:Message, args, title: title, symbol: 'i', &block)
      end
      alias info information

      # Creates a warning message section with a highlighted `title`  and
      # prints given additional arguments as lines into the section.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def warning(title, *args, &block)
        _section(:Message, args, title: title, symbol: '!', &block)
      end
      alias warn warning

      # Creates a error message section with a highlighted `title`  and
      # prints given additional arguments as lines into the section.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def error(title, *args, &block)
        _section(:Message, args, title: title, symbol: 'X', &block)
      end
      alias err error

      # Creates a completion message section with a highlighted `title`  and
      # prints given additional arguments as lines into the section.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def completed(title, *args, &block)
        _section(:Message, args, title: title, symbol: '✓', &block)
      end
      alias done completed
      alias ok completed

      # Creates a failure message section with a highlighted `title` and
      # prints given additional arguments as lines into the section.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def failed(title, *args, &block)
        _section(:Message, args, title: title, symbol: 'F', &block)
      end

      # Creates frame-enclosed section with a highlighted `title` and
      # prints given additional arguments as lines into the section.
      #
      # When no block is given, the section must be closed, see {Section#close}.
      #
      # @param [#to_s] title object to print as section title
      # @param [Array<#to_s>] args more objects to print
      # @param [Symbol] type frame type;
      #   valid types are `:rounded`, `:simple`, `:heavy`, `:semi`, `:double`
      # @yieldparam (see #section)
      # @return (see #section)
      def framed(title, *args, type: :rounded, &block)
        _section(:Framed, args, title: title, type: type, &block)
      end

      # Creates section with a H1 title.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def h1(title, *args, &block)
        _section(:Heading, args, title: title, weight: 1, &block)
      end

      # Creates section with a H2 title.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def h2(title, *args, &block)
        _section(:Heading, args, title: title, weight: 2, &block)
      end

      # Creates section with a H3 title.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def h3(title, *args, &block)
        _section(:Heading, args, title: title, weight: 3, &block)
      end

      # Creates section with a H4 title.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def h4(title, *args, &block)
        _section(:Heading, args, title: title, weight: 4, &block)
      end

      # Creates section with a H5 title.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def h5(title, *args, &block)
        _section(:Heading, args, title: title, weight: 5, &block)
      end

      # @!endgroup

      # @!group Instance Methods To Create Progression Elements

      # Creates task section.
      #
      # @param (see #information)
      # @yieldparam (see #section)
      # @return (see #section)
      def task(title, *args, &block)
        _section(:Task, args, title: title, &block)
      end

      # @!endgroup

      # @!group Instance Methods To Create Query Elements

      # Ask a yes/no question from user.
      #
      # The defaults for `yes` and `no` will work for
      # Afrikaans, Dutch, English, French, German, Italian, Polish, Portuguese,
      # Romanian, Spanish and Swedish.
      #
      # The default for `yes` includes `ENTER` and `RETURN` key
      #
      # @example
      #   case sec.ask('Do you like the NattyUI gem?')
      #   when true
      #     sec.info('Yeah!!')
      #   when false
      #     sec.write("That's pitty!")
      #   else
      #     sec.failed('You should have an opinion!')
      #   end
      #
      # @param question [#to_s] Question to display
      # @param yes [#to_s] chars which will be used to answer 'Yes'
      # @param no [#to_s] chars which will be used to answer 'No'
      # @return [Boolean] whether the answer is yes or no
      # @return [nil] when input was aborted with `ESC`, `^C` or `^D`
      def ask(question, yes: "jotsyd\r\n", no: 'n')
        _element(:Ask, question, yes, no)
      end

      # Ask choice from user.
      #
      # @example Select by Index
      #   choice = sec.query(
      #     'Which fruits do you prefer?',
      #     'Apples',
      #     'Bananas',
      #     'Cherries'
      #   )
      #   # => '1' or '2' or '3' or nil if user aborted
      #
      # @example Select by given char
      #   choice = sec.query(
      #     'Which fruits do you prefer?',
      #     a: 'Apples',
      #     b: 'Bananas',
      #     c: 'Cherries'
      #   )
      #   # => 'a' or 'b' or 'c' or nil if user aborted
      #
      # @param question [#to_s] Question to display
      # @param choices [#to_s] choices selectable via index (0..9)
      # @param result  [Symbol] defines how the result ist returned
      # @param kw_choices [{Char => #to_s}] choices selectable with given char
      # @return [Char] when `result` is configured as `:char`
      # @return [#to_s] when `result` is configured as `:choice`
      # @return [[Char, #to_s]] when `result` is configured as `:both`
      # @return [nil] when input was aborted with `ESC`, `^C` or `^D`
      def query(question, *choices, result: :char, **kw_choices)
        _element(:Query, question, choices, kw_choices, result)
      end

      # @!endgroup

      protected

      def _element(type, *args)
        wrapper
          .class
          .const_get(type)
          .__send__(:new, self)
          .__send__(:_call, *args)
      end

      def _section(type, args, **opts, &block)
        __section(self, type, args, **opts, &block)
      end

      def __section(owner, type, args, **opts, &block)
        sec = wrapper.class.const_get(type).__send__(:new, owner, **opts)
        sec.puts(*args) if args && !args.empty?
        block ? sec.__send__(:_call, &block) : sec
      end
    end
  end
end
