# frozen_string_literal: true

require 'stringio'

module NattyUI
  #
  # Tools class implementing the UI methods.
  #
  class Wrapper
    #
    # Helper class provided by {Wrapper#progress} to handle the progression
    # of a task.
    #
    class Progression
      # Progressionion state.
      #
      # @return [Symbol] when the progress was finsihed
      # @return [nil] when no state was reached yet
      attr_reader :state

      # Displayed message. Change this message to display a new state.
      #
      # @return [#to_s] current message
      attr_reader :message

      # @param value [#to_s]
      def message=(value)
        @message = value
        draw(true)
      end

      # Progression value. Increase this value to display the new progress.
      #
      # @return [Float] current value
      # @return [nil] when no value is configured
      attr_reader :value

      def value=(val)
        @value = val.to_f
        @value = 0 if @value < 0
        @max_value = @value if @max_value && @max_value < @value
        draw(true)
      end

      # Maximum progress value.
      #
      # @return [Float] configured value
      # @return [nil] when no maximum value is configured
      attr_reader :max_value

      # Test if is still in progress.
      #
      # @attribute [r] in_progress?
      # @return [Boolean] whether the progress is finished
      def in_progress? = @state.nil?

      # Test if the progression ended sucessfully.
      #
      # @attribute [r] ok?
      # @return [Boolean] whether the progression ended sucessfully
      def ok? = (@state == :ok)

      # Test if the progression failed.
      #
      # @attribute [r] failed?
      # @return [Boolean] whether the progression failed
      def failed? = (@state == :failed)

      # Signale some progress and optionally change {#message} and {#value}.
      #
      # @param message [#to_s] new message to be displayed
      # @param value [#to_f] new value to be used
      # @return [Progression] itself
      def step(message: nil, value: nil)
        @message = message if message
        self.value = (value || (@value + 1))
        self
      end

      # End the progression sucessfully.
      #
      # @see Wrapper#done
      #
      # @param messages [#to_s] optional messages to be displayd
      # @return [Progression] itself
      # @return [nil] when used in a {Wrapper#progress} block
      def done(*messages) = stop(:ok, messages)
      alias ok done

      # End the progression unsucessfully.
      #
      # @see Wrapper#failed
      #
      # @param messages [#to_s] optional messages to be displayd
      # @return [Progression] itself
      # @return [nil] when used in a {Wrapper#progress} block
      def failed(*messages) = stop(:failed, messages)

      alias _to_s to_s
      private :_to_s
      alias to_s message

      # @!visibility private
      def inspect
        "#{_to_s[..-2]} state=#{@state.inspect} value=#{@value.inspect} " \
          "message=#{@message.inspect}>"
      end

      # @!visibility private
      def initialize(wrapper, message, max_value)
        @wrapper = wrapper
        @message = message
        if max_value
          max_value = max_value.to_f
          @max_value = max_value if max_value > 0
        end
        @value = 0
        draw(false)
      end

      # @!visibility private
      def call
        @raise = true
        yield(self)
        done unless @state
      rescue BREAK
        nil
      end

      protected

      def draw(clear)
        msg =
          if @max_value && !@value.zero?
            "#{@message} #{
              format(
                '%.0f/%.0f (%.2f%%)',
                @value,
                @max_value,
                (@value / @max_value) * 100
              )
            }"
          else
            @message
          end
        return if msg == @last_msg
        @wrapper.stream << "\n" if clear
        (@wrapper.stream << (@last_msg = msg)).flush
      end

      def stop(state, messages)
        return self if @state
        @state = state
        clear_on_end
        if messages.empty?
          ok? ? @wrapper.done(message) : @wrapper.failed(message)
        else
          ok? ? @wrapper.done(*messages) : @wrapper.failed(*messages)
        end
        @raise ? raise(BREAK) : self
      end

      def clear_on_end = (@wrapper.stream << "\n")

      BREAK = Class.new(StandardError)
      private_constant :BREAK
    end

    # @return [IO] IO stream used for output
    attr_reader :stream

    # @attribute [r] ansi?
    # @return [Boolean] whether ANSI is supported
    def ansi? = false

    # @attribute [r] screen_size
    # @return [[Integer, Integer]] screen size as rows and columns
    def screen_size = [25, 79]

    # @attribute [r] screen_rows
    # @return [Integer] number of screen rows
    def screen_rows = 25

    # @attribute [r] screen_columns
    # @return [Integer] number of screen columns
    def screen_columns = 79

    # @!visibility private
    # @param [IO] stream used as output
    def initialize(stream)
      @stream = stream
    end

    # Write all internal buffers
    #
    # @return [Wrapper] itself
    def flush
      @stream.flush
      self
    end

    # @!group Text messages

    # Writes given `message` as the highlighted title and optionally further
    # arguments as associated text lines.
    #
    # @!method section(message, *args)
    # @param [#to_s] message to write
    # @param [#to_s] args further lines to write
    # @return [Wrapper] itself
    def section(...) = _section('•', ...)

    # Writes given `message` as the highlighted title of an informational text and
    # optionally further arguments as associated text lines.
    #
    # @!method info(message, *args)
    # @param [#to_s] message to write
    # @param [#to_s] args further lines to write
    # @return [Wrapper] itself
    def info(...) = _section('i', ...)

    # Writes given `message` as the highlighted title of a warning text and
    # optionally further arguments as associated text lines.
    #
    # @!method warning(message, *args)
    # @param [#to_s] message to write
    # @param [#to_s] args further lines to write
    # @return [Wrapper] itself
    def warning(...) = _section('!', ...)

    # Writes given `message` as the highlighted title of an error text and
    # optionally further arguments as associated text lines.
    #
    # @!method error(message, *args)
    # @param [#to_s] message to write
    # @param [#to_s] args further lines to write
    # @return [Wrapper] itself
    def error(...) = _section('X', ...)

    # Writes the given `message` as the highlighted title of a text describing
    # the successful end of a process and optionally further arguments as
    # associated text lines.
    #
    # @!method done(message, *args)
    # @param [#to_s] message to write
    # @param [#to_s] args further lines to write
    # @return [Wrapper] itself
    def done(...) = _section('✓', ...)

    # Writes the given `message` as the highlighted title of a text describing
    # the unsuccessful end of a process and optionally further arguments as
    # associated text lines.
    #
    # @!method failed(message, *args)
    # @param [#to_s] message to write
    # @param [#to_s] args further lines to write
    # @return [Wrapper] itself
    def failed(...) = _section('X', ...)

    alias write section
    alias warn warning
    alias err error
    alias ok done

    # @!endgroup

    # @!group Tool functions

    # Print given arguments to the output, may limit the output width.
    #
    # @param [Integer, nil] width limit of the output
    # @return [nil]
    def print(*args, width: nil)
      return @stream.print(*args) if width.nil?
      StringIO.open do |io|
        io.print(*args)
        io.rewind
        io.each(width, chomp: true) { |s| @stream.puts(s) }
      end
      nil
    ensure
      @stream.flush
    end

    # Print given arguments as lines to the output, may limit the output width.
    #
    # @param [Integer, nil] width limit of the output
    # @return [nil]
    def puts(*args, width: nil)
      return @stream.puts(*args) if width.nil?
      each_line(*args, width: width) { |s| @stream.puts(s) }
      nil
    ensure
      @stream.flush
    end

    # Use given ANSI `attributes` and automatically reset them after the block.
    #
    # @example
    #   UI.with(:bold, :red) { |ui| ui.puts('Hello World') }
    #
    # @see Ansi.[]
    #
    # @!method with(*attributes)
    # @param attributes [Symbol, String] attribute names to be used
    # @yield [Wrapper] itself
    # @return [Object] block result
    def with(*_attributes)
      block_given? ? yield(self) : self
    ensure
      @stream.flush
    end

    # Saves current screen, deletes all screen content and moves the cursor
    # to the top left screen corner. It restores the screen after the block.
    #
    # @example
    #   UI.page do |ui|
    #     ui.puts('Hello World')
    #     sleep 10
    #   end
    #
    # @yield [Wrapper] itself
    # @return [Object] block result
    def page
      block_given? ? yield(self) : self
    ensure
      @stream.flush
    end

    # Indicate progression of a task with a sequence of messages.
    #
    # @example Indicate progress of reading a file
    #  UI.progress('Reading file', max_value: file_size) do |progression|
    #    loop do
    #      read = file_read
    #      break if read.nil?
    #      progression.value += read.byte_size
    #    end
    #  end
    #
    # @example Indicate progress when the maximum amount is unknown
    #   UI.progress('Reading messages') do |progression|
    #     progression.step until read_finished
    #   end
    #
    # @example Indicate progress and actualize message
    #  UI.progress('Store data', max_value: 5) do |progression|
    #    create_file
    #    progression.step(message: 'gather data')
    #    gather_data
    #    progression.step(message: 'decode data')
    #    decode_data
    #    progression.step(message: 'format data')
    #    format_data
    #    progression.step(message: 'write data')
    #    write_date
    #    progression.done('Store data', 'All data sucessfully written to file')
    #  end
    #
    # @overload progress(message, max_value: nil)
    #   @param message [#to_s] to display
    #   @param max_value [Numeric, nil] maximum value of progress
    #   @return [Progression] the started progress
    #
    # @overload progress(message, max_value: nil)
    #   @param message [#to_s] to display
    #   @param max_value [Numeric, nil] maximum value of progress
    #   @yieldparam progress [Progression] the started progress
    #   @return [Object] the block result
    def progress(message, max_value: nil, &block)
      pro = create_progression(message, max_value)
      block ? pro.call(&block) : pro
    end

    # Ask choice from user.
    #
    # @example Select by Index
    #   choice = UI.query(
    #     'Which fruits do you prefer?',
    #     'Apples',
    #     'Bananas',
    #     'Cherries'
    #   )
    #   # => '1' or '2' or '3' or nil if user aborted
    #
    # @example Select by given char
    #   choice = UI.query(
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
      choices =
        Array
          .new(choices.size) { |i| i + 1 }
          .zip(choices)
          .to_h
          .merge!(kw_choices)
          .transform_keys! { |k| [k.to_s[0], ' '].max }
      return if choices.empty?
      arg = begin_query(question, choices)
      read_choice(choices, result)
    ensure
      end_query(arg) if arg
    end

    # Ask a yes/no question from user.
    #
    # The defaults for `yes` and `no` will work for
    # Afrikaans, Dutch, English, French, German, Italian, Polish, Portuguese,
    # Romanian, Spanish and Swedish.
    #
    # The default for `yes` includes `ENTER` and `RETURN` key
    #
    # @example
    #   case UI.ask('Do you like the NattyUI gem?')
    #   when true
    #     UI.info('Yeah!!')
    #   when false
    #     UI.write("That's pitty!")
    #   else
    #     UI.failed('You should have an opinion!')
    #   end
    #
    # @param question [#to_s] Question to display
    # @param yes [#to_s] chars which will be used to answer 'Yes'
    # @param no [#to_s] chars which will be used to answer 'No'
    # @return [Boolean] whether the answer is yes or no
    # @return [nil] when input was aborted with `ESC`, `^C` or `^D`
    def ask(question, yes: "jotsyd\r\n", no: 'n')
      yes = yes.to_s.chars.uniq
      no = no.to_s.chars.uniq
      raise(ArgumentError, ':yes can not be emoty') if yes.empty?
      raise(ArgumentError, ':no can not be emoty') if no.empty?
      unless (yes & no).empty?
        raise(ArgumentError, 'chars in :yes and :no can not be intersect')
      end
      arg = begin_asking(question)
      read_answer(yes, no)
    ensure
      end_asking(arg) if arg
    end

    # @!endgroup

    protected

    def each_line(*args, width: nil, &block)
      StringIO.open do |io|
        io.puts(*args)
        io.rewind
        return io.each(chomp: true, &block) if width.nil?
        io.each(width, chomp: true, &block)
      end
    end

    def create_progression(message, max_value)
      Progression.new(self, message, max_value)
    end

    def _section(symbol, msg, *args)
      @stream.puts("#{symbol} #{msg.to_s.lstrip}")
      unless args.empty?
        each_line(*args) { |s| @stream << '  ' << s.lstrip << "\n" }
      end
      flush
    end

    def begin_query(question, choices)
      @stream << "▶︎ #{question}\n"
      choices.each_pair { |key, msg| @stream.puts("  #{key}: #{msg}") }
      @stream.flush
      false
    end

    def begin_asking(question)
      (@stream << question << ' ').flush
      true
    end

    def end_asking(_) = (@stream << "\n").flush

    private

    def read_answer(yes, no)
      while true
        char = NattyUI.in_stream.getch
        return if "\u0003\u0004\e".include?(char)
        return true if yes.include?(char)
        return false if no.include?(char)
      end
    end

    def read_choice(choices, result)
      while true
        char = NattyUI.in_stream.getch
        return if "\u0003\u0004\e".include?(char)
        next unless choices.key?(char)
        return char if result == :char
        return choices[char] if result == :choice
        return char, choices[char]
      end
    end
  end
end
