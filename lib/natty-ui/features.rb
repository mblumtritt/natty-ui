# frozen_string_literal: true

module NattyUI
  # These are all supported features by {NattyUI} or any other sub- element
  # like {section}, {message}, {task}, ...
  #
  # Any printed text can contain *BBCode*-like embedded ANSI attributes which
  # will be used when the output terminal supports attributes and colors.
  #
  module Features
    #
    # @!group Printing Methods
    #

    # Print given text as lines.
    #
    # @example Print two lines text, right aligned
    #   ui.puts("Two lines", "of nice text", align: :right)
    #   # =>    Two lines
    #   # => of nice text
    #
    # @example Print two lines text, with a prefix
    #   ui.puts("Two lines", "of nice text", prefix: ': ')
    #   # => : Two lines
    #   # => : of nice text
    #
    # @see #pin
    #
    # @param text [#to_s]
    #   one or more convertible objects to print line by line
    # @param options [{Symbol => Object}]
    # @option options [:left, :right, :centered] :align (:left)
    #   text alignment
    # @option options [true, false] :ignore_newline (false)
    #   whether to igniore newline characters
    #
    # @return [Features]
    #   itself
    def puts(*text, **options)
      bbcode = true if (bbcode = options[:bbcode]).nil?
      max_width = options[:max_width] || Terminal.columns

      prefix_width =
        if (prefix = options[:prefix])
          prefix = Ansi.bbcode(prefix) if bbcode
          options[:prefix_width] || Text.width(prefix, bbcode: false)
        else
          0
        end

      if (first_line = options[:first_line_prefix])
        first_line = Ansi.bbcode(first_line) if bbcode
        first_line_width =
          options[:first_line_prefix_width] ||
            Text.width(first_line, bbcode: false)

        if prefix_width < first_line_width
          prefix_next = "#{prefix}#{' ' * (first_line_width - prefix_width)}"
          prefix = first_line
          prefix_width = first_line_width
        else
          prefix_next = prefix
          prefix =
            if first_line_width < prefix_width
              first_line + (' ' * (prefix_width - first_line_width))
            else
              first_line
            end
        end
      end

      max_width -= prefix_width

      if (suffix = options[:suffix])
        suffix = Ansi.bbcode(suffix) if bbcode
        max_width -= options[:suffix_width] || Text.width(suffix, bbcode: false)
      end

      return self if max_width <= 0

      lines =
        Text.each_line_with_size(
          *text,
          limit: max_width,
          bbcode: bbcode,
          ansi: Terminal.ansi?,
          ignore_newline: options[:ignore_newline]
        )

      if (align = options[:align]).nil?
        lines.each do |line|
          Terminal.print(prefix, line, suffix, EOL__, bbcode: false)
          @lines_written += 1
          prefix, prefix_next = prefix_next, nil if prefix_next
        end
        return self
      end

      unless options[:expand]
        lines = lines.to_a
        max_width = lines.max_by(&:last).last
      end

      case align
      when :right
        lines.each do |line, width|
          Terminal.print(
            prefix,
            ' ' * (max_width - width),
            line,
            suffix,
            EOL__,
            bbcode: false
          )
          @lines_written += 1
          prefix, prefix_next = prefix_next, nil if prefix_next
        end
      when :centered
        lines.each do |line, width|
          space = max_width - width
          Terminal.print(
            prefix,
            ' ' * (lw = space / 2),
            line,
            ' ' * (space - lw),
            suffix,
            EOL__,
            bbcode: false
          )
          @lines_written += 1
          prefix, prefix_next = prefix_next, nil if prefix_next
        end
      else
        lines.each do |line, width|
          Terminal.print(
            prefix,
            line,
            ' ' * (max_width - width),
            suffix,
            EOL__,
            bbcode: false
          )
          @lines_written += 1
          prefix, prefix_next = prefix_next, nil if prefix_next
        end
      end
      self
    end

    # Print given text as lines like {#puts}. Used in elements with temporary
    # output like {#task} the text will be kept ("pinned").
    #
    # It can optionally have a decoration marker in first line like {#mark}.
    #
    # @example Print two lines decorated as information which are pinned
    #   ui.task 'Do something important' do |task|
    #     # ...
    #     task.pin("This is text", "which is pinned", mark: :information)
    #     # ...
    #   end
    #   # => ✓ Do something important
    #   # =>   𝒊 This is text
    #   # =>     which is pinned.
    #
    # @param (see #puts)
    # @param mark (see #mark)
    # @option (see #puts)
    #
    # @return (see puts)
    def pin(*text, mark: nil, **options)
      options[:pin] = true
      options[:first_line_prefix] = Theme.current.mark(mark) if mark
      puts(*text, **options)
    end

    # Print given text with a decoration mark.
    #
    # @param text (see puts)
    # @param mark [Symbol, #to_s]
    #   marker type
    #
    # @return (see puts)
    def mark(*text, mark: :default)
      mark = Theme.current.mark(mark)
      puts(*text, first_line_prefix: mark, first_line_prefix_width: mark.width)
    end

    # Print given text as a quotation.
    #
    # @param text (see puts)
    #
    # @return (see puts)
    def quote(*text)
      width = columns * 0.75
      quote = Theme.current.mark(:quote)
      puts(
        *text,
        prefix: quote,
        prefix_width: quote.width,
        max_width: width < 20 ? nil : width.to_i
      )
    end

    # Print given text as a heading.
    #
    # There are specific shortcuts for heading levels:
    # {#h1}, {#h2}, {#h3}, {#h4}, {#h5}, {#h6}.
    #
    # @example Print a level 1 heading
    #   ui.heading(1, 'This is a H1 heading element')
    #   # => ╴╶╴╶─═══ This is a H1 heading element ═══─╴╶╴╶
    #
    # @param level [#to_i]
    #   heading level, one of 1..6
    # @param text (see puts)
    #
    # @return (see puts)
    def heading(level, *text)
      prefix, suffix = Theme.current.heading(level)
      puts(
        *text,
        max_width: columns,
        prefix: prefix,
        prefix_width: prefix.width,
        suffix: suffix,
        suffix_width: suffix.width,
        align: :centered
      )
    end

    # Print given text as a H1 {#heading}.
    #
    # @param text (see puts)
    #
    # @return (see puts)
    def h1(*text) = heading(1, *text)

    # Print given text as a H2 {#heading}.
    #
    # @param text (see puts)
    #
    # @return (see puts)
    def h2(*text) = heading(2, *text)

    # Print given text as a H3 {#heading}.
    #
    # @param text (see puts)
    #
    # @return (see puts)
    def h3(*text) = heading(3, *text)

    # Print given text as a H4 {#heading}.
    #
    # @param text (see puts)
    #
    # @return (see puts)
    def h4(*text) = heading(4, *text)

    # Print given text as a H5 {#heading}.
    #
    # @param text (see puts)
    #
    # @return (see puts)
    def h5(*text) = heading(5, *text)

    # Print given text as a H6 {#heading}.
    #
    # @param text (see puts)
    #
    # @return (see puts)
    def h6(*text) = heading(6, *text)

    # Print a horizontal rule.
    #
    # @example
    #   ui.hr(:heavy)
    #
    # @param type [Symbol]
    #   border type
    #
    # @return (see puts)
    def hr(type = :default)
      theme = Theme.current
      bc = theme.border(type)[10]
      puts("#{theme.heading_sytle}#{bc * columns}")
    end

    # Print one or more space lines.
    #
    # @param count [#to_i]
    #   lines to print
    #
    # @return (see puts)
    def space(count = 1)
      (count = count.to_i).positive? ? puts(*Array.new(count, "\n")) : self
    end

    # Print given items as list (like 'ls' command).
    #
    # Each list item will optionally be decorated with the given glyph as:
    #
    # - `Integer` as the start value for a numbered list
    # - `Symbol` as the start symbol
    # - `:hex` to create a hexadecimal numbered list
    # - any text as prefix
    #
    # @example Print all Ruby files as a numbered list
    #   ui.ls(Dir['*/**/*.rb'], glyph: 1)
    #
    # @example Print all Ruby files as a bullet point list (with green bullets)
    #   ui.ls(Dir['*/**/*.rb'], glyph: '[green]•[/fg]')
    #
    # @param items [#to_s]
    #   one or more convertible objects to list
    # @param compact [true, false]
    #   whether the compact display format should be used
    # @param glyph [Integer, :hex, Symbol, #to_s]
    #   glyph to be used as prefix
    #
    # @return (see puts)
    def ls(*items, compact: true, glyph: nil)
      return self if items.empty?
      renderer = compact ? CompactLSRenderer : LSRenderer
      puts(*renderer.lines(items, glyph, columns))
    end

    # Generate and print a table.
    # See {Table} for much more details about table generation.
    #
    # @example Draw a very simple table with three rows, four columns, complete borders
    #   ui.table(border: :default, border_around: true, padding: [0, 1]) do |table|
    #     table.add 1, 2, 3, 4
    #     table.add 5, 6, 7, 8
    #     table.add 9, 10, 11, 12
    #   end
    #
    # @param attributes [{Symbol => Object}]
    #   attributes for the table and default attributes for table cells
    # @option attributes [Symbol] :border (nil)
    #   kind of border,
    #   see {Attributes::Border}
    # @option attributes [true, false] :border_around (false)
    #   whether the table should have a border around,
    #   see {Attributes::BorderAround}
    # @option attributes [Enumerable<Symbol>] :border_style (nil)
    #   style of border,
    #   see {Attributes::BorderStyle}
    #
    # @yieldparam table [Table]
    #   helper to define the table layout
    #
    # @return (see puts)
    def table(**attributes)
      return self unless block_given?
      yield(table = Table.new(**attributes))
      puts(*TableRenderer[table, columns])
    end

    # Print text in columns.
    # This is a shorthand to define a {Table} with a single row.
    #
    # @param columns [#to_s]
    #   two or more convertible objects to print side by side
    # @param attributes (see table)
    # @option attributes (see table)
    # @option attributes [Integer] :width (nil)
    #   width of a column,
    #   see {Attributes::Width}
    #
    # @yieldparam row [Table::Row]
    #   helper to define the row layout
    #
    # @return (see puts)
    def cols(*columns, **attributes)
      table(**attributes) do |table|
        table.add do |row|
          columns.each { row.add(_1, **attributes) }
          yield(row) if block_given?
        end
      end
    end

    # Print a text division with attributes.
    # This is a shorthand to define a {Table} with a single cell.
    #
    # @param text (see puts)
    # @param attributes [{Symbol => Object}]
    #   attributes for the division
    # @option attributes [:left, :right, :centered] :align (:left)
    #   text alignment,
    #   see {Attributes::Align}
    # @option attributes [Integer, Enumerable<Integer>] :padding (nil)
    #   text padding,
    #   see {Attributes::Padding}
    # @option attributes [Enumerable<Symbol>] :style (nil)
    #   text style,
    #   see {Attributes::Style}
    # @option attributes [Integer] :width (nil)
    #   width of the cell,
    #   see {Attributes::Width}
    # @option attributes (see table)
    #
    # @return (see puts)
    def div(*text, **attributes)
      return self if text.empty?
      table(border_around: true, **attributes) do |table|
        table.add { _1.add(*text, **attributes) }
      end
    end

    # Dynamically display a task progress.
    # When a `max` parameter is given the progress will be displayed as a
    # progress bar below the `title`. Otherwise the progress is displayed just
    # by accumulating dots.
    #
    # @example Display a progress bar
    #   ui.progress('Download file', max: 1024) do |progress|
    #     while progress.value < progress.max
    #       # just to simulate the download
    #       sleep(0.1)
    #       bytes_read = rand(10..128)
    #
    #       # here we actualize the progress
    #       progress.value += bytes_read
    #     end
    #   end
    #
    # @example Display simple progress
    #   progress = ui.progress('Check some stuff')
    #   10.times do
    #     # simulate some work
    #     sleep(0.1)
    #
    #     # here we actualize the progress
    #     progress.step
    #   end
    #   progress.ok('Stuff checked ok')
    #
    # @overload progress(title, max: nil, pin: false)
    #   @param title [#to_s]
    #     title text to display
    #   @param max [#to_f]
    #     expected maximum value
    #   @param pin [true, false]
    #     whether the final progress state should be "pinned" to parent element
    #
    #   @return [Progress]
    #     itself
    #
    # @overload progress(title, max: nil, pin: false, &block)
    #   @param title [#to_s]
    #     title text
    #   @param max [#to_f]
    #     expected maximum value
    #   @param pin [true, false]
    #     whether the final progress state should be "pinned" to parent element
    #
    #   @yieldparam progress [Progress]
    #     itself
    #
    #   @return [Object]
    #     the result of the given block
    def progress(title, max: nil, pin: false, &block)
      progress =
        if Terminal.ansi?
          Progress.new(self, title, max, pin)
        else
          DumbProgress.new(self, title, max)
        end
      block ? __with(progress, &block) : progress
    end

    #
    # @!endgroup
    #

    #
    # @!group Sub-Elements
    #

    # Create a visually separated section for the output of text elements.
    # Like any other {Element} sections support all {Features}.
    #
    # @example
    #   ui.section do |section|
    #     section.h1('About Sections')
    #     section.space
    #     section.puts('Sections are areas of text elements.')
    #     section.puts('You can use any other feature inside such an area.')
    #   end
    #   # => ╭────╶╶╶
    #   # => │ ╴╶╴╶─═══ About Sections ═══─╴╶╴╶
    #   # => │
    #   # => │ Sections are areas of text elements.
    #   # => │ You can use any other feature inside such an area.
    #   # => ╰──── ─╶╶╶
    #
    # @param text [#to_s]
    #   convertible objects to print line by line
    #
    # @yieldparam section [Section]
    #   itself
    #
    # @return [Object]
    #   the result of the given block
    def section(*text, &block) = __sec(:default, nil, text, &block)

    # @!macro like_msg
    #   @see section
    #   @param title [#to_s]
    #     title to print as section head
    #   @param text (see section)
    #   @yieldparam (see section)
    #   @return (see section)

    # Create a visually separated section with a title for the output of text
    # elements.
    #
    # @macro like_msg
    def message(title, *text, &block) = __sec(:message, title, text, &block)
    alias msg message

    # Create a visually separated section marked as informational with a title
    # for the output of text elements.
    #
    # @macro like_msg
    def information(title, *text, &block)
      __tsec(:information, title, text, &block)
    end
    alias info information

    # Create a visually separated section marked as a warning with a title for
    # the output of text elements.
    #
    # @macro like_msg
    def warning(title, *text, &block) = __tsec(:warning, title, text, &block)
    alias warn warning

    # Create a visually separated section marked as an error with a title for
    # the output of text elements.
    #
    # @macro like_msg
    def error(title, *text, &block) = __tsec(:error, title, text, &block)
    alias err error

    # Create a visually separated section marked as a failure with a title for
    # the output of text elements.
    #
    # @macro like_msg
    def failed(title, *text, &block) = __tsec(:failed, title, text, &block)

    # Create a framed section.
    #
    # @param text (see section)
    # @param align [:left, :right, :centered]
    #   text alignment,
    #   see {Attributes::Align}
    # @param border: [Symbol]
    #   kind of border,
    #   see {Attributes::Border}
    # @param border_style [Enumerable<Symbol>]
    #   style of border,
    #   see {Attributes::BorderStyle}
    #
    # @yieldparam frame [Framed] itself
    #
    # @return (see section)
    def framed(*text, align: :left, border: :default, border_style: nil, &block)
      __with(
        Framed.new(
          self,
          Utils.align(align),
          Theme.current.border(border),
          Utils.style(border_style),
          text
        ),
        &block
      )
    end

    # Generate a task section.
    #
    # @param title [#to_s]
    #   task title text
    # @param text (see section)
    # @param pin [true, false] whether to keep text "pinned"
    #
    # @yieldparam task [Task] itself
    #
    # @return (see section)
    def task(title, *text, pin: false, &block)
      __with(Task.new(self, title, text, pin), &block)
    end

    #
    # @!endgroup
    #

    #
    # @!group User Interaction
    #

    # Wait for user input.
    #
    # @example Wait until user wants to coninue
    #   ui.await { ui.puts '[faint][\\Press ENTER to continue...][/faint]' }
    #
    # @example Ask yes/no-question
    #   ui.await(yes: %w[j o t s y d Enter], no: %w[n Esc]) do
    #     ui.puts 'Do you like NayttUI?'
    #   end
    #   # => true, for user's YES
    #   # => false, for user's NO
    #   # Info:
    #   # The keys will work for Afrikaans, Dutch, English, French, German,
    #   # Italian, Polish, Portuguese, Romanian, Spanish and Swedish.
    #
    # @overload await(yes: 'Enter', no: 'Esc')
    #   @param yes [String, Enumerable<String>]
    #     key code/s a user can input to return positive result
    #   @param no [String, Enumerable<String>]
    #     key code/s a user can input to return negative resault
    #
    #   @return [true, false]
    #     wheter the user inputs a positive result
    #
    # @overload await(yes: 'Enter', no: 'Esc', &block)
    #   @param yes [String, Enumerable<String>]
    #     key code/s a user can input to return positive result
    #   @param no [String, Enumerable<String>]
    #     key code/s a user can input to return negative resault
    #
    #   @yieldparam temp [Temporary]
    #     temporary displayed section (section will be erased after input)
    #
    #   @return [true, false]
    #     wheter the user inputs a positive result
    #
    def await(yes: 'Enter', no: 'Esc')
      temporary do |arg|
        yield(arg) if block_given?
        while (key = Terminal.read_key)
          if (no == key) || (no.is_a?(Enumerable) && no.include?(key))
            return false
          end
          if (yes == key) || (yes.is_a?(Enumerable) && yes.include?(key))
            return true
          end
        end
      end
    end

    # Request a user's chocie.
    #
    # @overload choice(*choices, abortable: false)
    #   @param [#to_s] choices
    #     one or more alternatives to select from
    #   @param [true, false] abortable
    #     whether the user is allowed to abort with 'Esc' or 'Ctrl+c'
    #
    #   @return [Integer]
    #     index of selected choice
    #   @return [nil]
    #     when user aborted the selection
    #
    # @overload choice(*choices, abortable: false, &block)
    #   @example Request a fruit
    #     ui.choice('Apple', 'Banana', 'Orange') { ui.puts 'What do you prefer?' }
    #     # => 0, when user likes apples
    #     # => 1, when bananas are user's favorite
    #     # => 2, when user is a oranges lover
    #
    #   @param [#to_s] choices
    #     one or more alternatives to select from
    #   @param [true, false] abortable
    #     whether the user is allowed to abort with 'Esc' or 'Ctrl+c'
    #
    #   @yieldparam temp [Temporary]
    #     temporary displayed section (section will be erased after input)
    #
    #   @return [Integer]
    #     index of selected choice
    #   @return [nil]
    #     when user aborted the selection
    #
    # @overload choice(**choices, abortable: false)
    #   @param [#to_s] choices
    #     one or more alternatives to select from
    #   @param [true, false] abortable
    #     whether the user is allowed to abort with 'Esc' or 'Ctrl+c'
    #
    #   @return [Object]
    #     key for selected choice
    #   @return [nil]
    #     when user aborted the selection
    #
    # @overload choice(**choices, abortable: false, &block)
    #   @example Request a preference
    #     ui.choice(
    #       k: 'Kitty',
    #       i: 'iTerm2',
    #       g: 'Ghostty',
    #       t: 'Tabby',
    #       r: 'Rio',
    #       abortable: true
    #     ) { ui.puts 'Which terminal emulator do you like?' }
    #     # => wheter the user selected: :k, :i, :g, :t, :r
    #     # => nil, when the user aborted
    #   @param [#to_s] choices
    #     one or more alternatives to select from
    #   @param [true, false] abortable
    #     whether the user is allowed to abort with 'Esc' or 'Ctrl+c'
    #
    #   @yieldparam temp [Temporary]
    #     temporary displayed section (section will be erased after input)
    #
    #   @return [Object]
    #     key for selected choice
    #   @return [nil]
    #     when user aborted the selection
    #
    def choice(*choices, abortable: false, **kwchoices, &block)
      return if choices.empty? && kwchoices.empty?
      choice =
        case NattyUI.input_mode
        when :default
          Choice.new(self, choices, kwchoices, abortable)
        when :dumb
          DumbChoice.new(self, choices, kwchoices, abortable)
        else
          return
        end
      __with(choice) { choice.select(&block) }
    end

    #
    # @!endgroup
    #

    #
    # @!group Utilities
    #

    # @!visibility private
    def columns = Terminal.columns

    # Display some temporary content.
    # The content displayed in the block will be erased after the block ends.
    #
    # @example Show tempoary information
    #   ui.temporary do
    #     ui.info('Information', 'This text will disappear when you pressed ENTER.')
    #     ui.await
    #   end
    #
    # @yieldparam temp [Temporary]
    #   itself
    #
    # @return (see section)
    def temporary(&block) = __with(Temporary.new(self), &block)

    #
    # @!endgroup
    #

    private

    def __with(element, &block) = NattyUI.__send__(:with, element, &block)

    def __sec(color, title, text, &block)
      __with(Section.new(self, title, text, color), &block)
    end

    def __tsec(color, title, text, &block)
      __sec(color, "#{Theme.current.mark(color)}#{title}", text, &block)
    end

    EOL__ = Terminal.ansi? ? "\e[m\n" : "\n"
    private_constant :EOL__
  end

  dir = __dir__
  autoload :Choice, "#{dir}/choice.rb"
  autoload :CompactLSRenderer, "#{dir}/ls_renderer.rb"
  autoload :DumbChoice, "#{dir}/dumb_choice.rb"
  autoload :Framed, "#{dir}/framed.rb"
  autoload :LSRenderer, "#{dir}/ls_renderer.rb"
  autoload :Progress, "#{dir}/progress.rb"
  autoload :DumbProgress, "#{dir}/progress.rb"
  autoload :Section, "#{dir}/section.rb"
  autoload :Table, "#{dir}/table.rb"
  autoload :Task, "#{dir}/task.rb"
  autoload :Temporary, "#{dir}/temporary.rb"
  autoload :Theme, "#{dir}/theme.rb"
  autoload :Utils, "#{dir}/utils.rb"

  private_constant :Choice, :DumbChoice, :LSRenderer, :CompactLSRenderer
end
