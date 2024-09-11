# frozen_string_literal: true

module NattyUI
  #
  # Helper module for ANSI escape codes.
  #
  module Ansi
    class << self
      # Supported attribute names.
      #
      # @see []
      #
      # @attribute [r] attribute_names
      # @return [Array<Symbol>] all attribute names
      def attribute_names = ATTRIBUTES_S.keys

      # Supported basic color names.
      #
      # @see []
      #
      # @attribute [r] color_names
      # @return [Array<Symbol>] all basic color names
      def color_names = COLORS_S.keys

      # Defined named colors (24bit colors).
      #
      # *Remark*: Named colors follow the same name schema and color palette
      # as supported by Kitty.
      #
      # @see []
      #
      # @attribute [r] named_colors
      # @return [Array<String>] all named colors
      def named_colors = NAMED_COLORS.keys

      # @!group Control functions

      # Move cursor given lines up.
      #
      # @param lines [Integer] number of lines to move
      # @return [String] ANSI control code
      def cursor_up(lines = 1) = "\e[#{lines}A"

      # Move cursor given lines down.
      #
      # @param (see cursor_up)
      # @return (see cursor_up)
      def cursor_down(lines = 1) = "\e[#{lines}B"

      # Move cursor given colums forward.
      #
      # @param columns [Integer] number of columns to move
      # @return (see cursor_up)
      def cursor_forward(columns = 1) = "\e[#{columns}C"

      # Move cursor given colums back.
      #
      # @param (see cursor_forward)
      # @return (see cursor_up)
      def cursor_back(columns = 1) = "\e[#{columns}D"

      # Move cursor of beginning of the given next line.
      #
      # @param (see cursor_up)
      # @return (see cursor_up)
      def cursor_next_line(lines = 1) = "\e[#{lines}E"

      # Move cursor of beginning of the given previous line.
      #
      # @param (see cursor_up)
      # @return (see cursor_up)
      def cursor_previous_line(lines = 1) = "\e[#{lines}F"
      alias cursor_prev_line cursor_previous_line

      # Move cursor to given column in the current row.
      #
      # @param column [Integer] column index
      # @return (see cursor_up)
      def cursor_column(column = 1) = "\e[#{column}G"

      # Move cursor to given row and column counting from the top left corner.
      #
      # @param row [Integer] row index
      # @param column [Integer] column index
      # @return (see cursor_up)
      def cursor_pos(row, column = nil)
        return column ? "\e[#{row};#{column}H" : "\e[#{row}H" if row
        column ? "\e[;#{column}H" : "\e[H"
      end

      # @comment ??? def cursor_tab(count = 1) = "\e[#{column}I"

      # Erase screen.
      #
      # @param part [:below, :above, :scrollback, :entire] part to erase
      # @return (see cursor_up)
      def screen_erase(part = :entire)
        return "\e[0J" if part == :below
        return "\e[1J" if part == :above
        return "\e[3J" if part == :scrollback
        "\e[2J"
      end

      # Clear part of current line.
      #
      # @param part [:to_end, :to_start, :entire] part to delete
      # @return (see cursor_up)
      def line_erase(part = :entire)
        return "\e[0K" if part == :to_end
        return "\e[1K" if part == :to_start
        "\e[2K"
      end

      # @comment ??? def line_insert(lines = 1) = "\e[#{lines}L"
      # @comment ??? def line_delete(lines = 1) = "\e[#{lines}M"
      # @comment ??? def chars_delete(count = 1) = "\e[#{count}P"

      # Scroll window given lines up.
      #
      # @param lines [Integer] number of lines to scroll
      # @return (see cursor_up)
      def scroll_up(lines = 1) = "\e[;#{lines}S"

      # Scroll window given lines down.
      #
      # @param (see scroll_up)
      # @return (see cursor_up)
      def scroll_down(lines = 1) = "\e[;#{lines}T"

      # @comment ??? def chars_erase(count = 1) = "\e[#{count}X"
      # @comment ??? def cursor_reverse_tab(count = 1) = "\e[#{count}Z"

      # set absolute col
      # @comment ??? doubled! def cursor_column(column = 1) = "\e[#{column}`"
      # set relative column
      # @comment ??? def cursor_column_rel(column = 1) = "\e[#{column}a"
      # set absolute row
      # @comment ??? def cursor_row(row = 1) = "\e[#{row}d"
      # set relative row
      # @comment ??? def cursor_row_rel(row = 1) = "\e[#{row}e"

      # Change window title.
      # This is not widely supported.
      #
      # @param [String] title text
      # @return (see cursor_up)
      def window_title(title) = "\e]2;#{title}\e\\"

      # Change tab title.
      # This is not widely supported.
      #
      # @param [String] title text
      # @return (see cursor_up)
      def tab_title(title) = "\e]0;#{title}\a"

      # Create a hyperlink.
      # This is not widely supported.
      def link(url, text) = "\e]8;;#{url}\e\\#{text}\e]8;;\e\\"

      # @!endgroup

      # @!group Tool functions

      # Combine given ANSI {.attribute_names}, {.color_names} and color codes.
      #
      # Colors can specified by their name for ANSI 3-bit and 4-bit colors.
      # For 8-bit ANSI colors use 2-digit hexadecimal values `00`...`ff`.
      #
      # To use RGB ANSI colors (24-bit colors) specify 3-digit or 6-digit
      # hexadecimal values `000`...`fff` or `000000`...`ffffff`.
      # This represent the `RRGGBB` values (or `RGB` for short version) like you
      # may known from CSS color notation.
      #
      # To use a color as background color prefix the color attribute with `bg_`
      # or `on_`.
      # To use a color as underline color prefix the color attribute with `ul_`.
      # To clarify that a color attribute have to be used as foreground
      # color use the prefix `fg_`.
      #
      # @example Valid Foreground Color Attributes
      #   Ansi[:yellow]
      #   Ansi[:fg_fab]
      #   Ansi[:fg_00aa00]
      #   Ansi[:af]
      #   Ansi[:fg_af]
      #   Ansi['#fab']
      #   Ansi['#00aa00']
      #   Ansi['lightblue']
      #
      # @example Valid Background Color Attributes
      #   Ansi[:bg_yellow]
      #   Ansi[:bg_fab]
      #   Ansi[:bg_af]
      #   Ansi[:bg_00aa00]
      #   Ansi['bg#00aa00']
      #   Ansi['bg_lightblue']
      #
      #   Ansi[:on_yellow]
      #   Ansi[:on_fab]
      #   Ansi[:on_00aa00]
      #   Ansi[:on_af]
      #   Ansi['on#00aa00']
      #   Ansi['on_lightblue']
      #
      # @example Valid Underline Color Attributes
      #   Ansi[:underline, :ul_yellow]
      #   Ansi[:underline, :ul_fab]
      #   Ansi[:underline, :ul_00aa00]
      #   Ansi[:underline, :ul_fa]
      #   Ansi[:underline, :ul_bright_yellow]
      #   Ansi[:underline, 'ul#00aa00']
      #   Ansi['underline', 'ul_lightblue']
      #
      # @example Combined attributes:
      #   Ansi[:bold, :italic, :bright_white, :on_0000cc]
      #
      # @param attributes [Array<Symbol, String>] attribute names to be used
      # @return [String] combined ANSI attributes
      def [](*attributes)
        return '' if attributes.empty?
        "\e[#{
          attributes
            .map do |arg|
              case arg
              when Symbol
                ATTRIBUTES_S[arg] || COLORS_S[arg] || color(arg) ||
                  invalid_argument(arg)
              when String
                ATTRIBUTES[arg] || COLORS[arg] || color(arg) ||
                  invalid_argument(arg)
              when (0..255)
                "38;5;#{arg}"
              when (256..511)
                "48;5;#{arg - 256}"
              when (512..767)
                "58;5;#{arg - 512}"
              else
                invalid_argument(arg)
              end
            end
            .join(';')
        }m"
      end

      # Decorate given `str` with ANSI attributes and colors.
      #
      # @see []
      #
      # @param str [#to_s] object to be decorated
      # @param attributes [Symbol, String] attribute names to be used
      # @param reset [Boolean] whether to include reset code for ANSI attributes
      # @return [String] `str` converted and decorated with the ANSI `attributes`
      def embellish(str, *attributes, reset: true)
        attributes = self[*attributes]
        attributes.empty? ? str.to_s : "#{attributes}#{str}#{"\e[m" if reset}"
      end

      # Remove ANSI functions, attributes and colors from given string.
      #
      # @see embellish
      #
      # @param str [#to_s] string to be modified
      # @return [String] string without ANSI attributes
      def blemish(str) = str.to_s.gsub(ESC, '')

      # Try to combine given ANSI attributes and colors.
      # The attributes and colors have to be seperated by space char (" ").
      #
      # @example Valid Attribute String
      #   Ansi.try_convert('bold italic blink red on#00ff00')
      #   # => ANSI attribute string for bold, italic text which blinks red on
      #   #    green background
      #
      # @example Invalid Attribute String
      #   Ansi.try_convert('cool bold on green')
      #   # => nil
      #
      # @param attributes [#to_s] attributes separated by space char (" ")
      # @return [String] combined ANSI attributes
      # @return [nil] when string does not contain valid attributes
      def try_convert(attributes)
        return if !attributes || (attributes = attributes.to_s.split).empty?
        "\e[#{
          attributes
            .map! { ATTRIBUTES[_1] || COLORS[_1] || color(_1) || return }
            .join(';')
        }m"
      end

      # @param str [#to_s] plain text string to enrich with color
      # @param type [:foreground, :background, :underline] type of coloring
      # @param frequence [Float] color change frequency
      # @param spread [Float] number of chars with same color
      # @param seed [Float] start index on sinus curve
      # @return [String] fancy text
      def rainbow(
        str,
        type: :foreground,
        frequence: 0.3,
        spread: 0.8,
        seed: 1.1
      )
        type = color_type(type)
        pos = -1
        str
          .to_s
          .chars
          .map! do |char|
            i = (seed + ((pos += 1) / spread)) * frequence
            "\e[#{type};2;#{(Math.sin(i) * 255).abs.to_i};" \
              "#{(Math.sin(i + PI2_THIRD) * 255).abs.to_i};" \
              "#{(Math.sin(i + PI4_THIRD) * 255).abs.to_i}m#{char}"
          end
          .join
      end

      # @!endgroup

      private

      def invalid_argument(name)
        raise(
          ArgumentError,
          "unknown Ansi attribute name - '#{name}'",
          caller(1)
        )
      end

      def color(str)
        if /\A(?<base>fg|bg|on|ul)?[_:]?#?(?<val>[[:xdigit:]]{1,6})\z/ =~ str
          return(
            case val.size
            when 1, 2
              "#{color_base(base)};5;#{val.hex}"
            when 3
              "#{color_base(base)};2;#{(val[0] * 2).hex};#{
                (val[1] * 2).hex
              };#{(val[2] * 2).hex}"
            when 6
              "#{color_base(base)};2;#{val[0, 2].hex};#{val[2, 2].hex};#{
                val[4, 2].hex
              }"
            end
          )
        end
        if /\A(?<base>fg|bg|on|ul)?[_:]?(?<val>[a-z]{3,}[0-9]{0,3})\z/ =~ str
          val = NAMED_COLORS[val] and return "#{color_base(base)};#{val}"
        end
      end

      def color_base(base)
        return '48' if base == 'bg' || base == 'on'
        base == 'ul' ? '58' : '38'
      end

      def color_type(type)
        case type
        when :background, :bg, 'background', 'bg'
          48
        when :underline, :ul, 'underline', 'ul'
          58
        else
          38
        end
      end
    end

    # @!visibility private
    CSI = /\e\[[\d;:]*[ABCDEFGHJKSTfminsuhl]/

    # @!visibility private
    OSC = /\e\]\d+(?:;[^;\a\e]+)*(?:\a|\e\\)/

    ESC = /(#{CSI})|(#{OSC})/

    PI2_THIRD = 2 * Math::PI / 3
    PI4_THIRD = 4 * Math::PI / 3

    autoload(:NAMED_COLORS, File.join(__dir__, 'ansi', 'named_colors'))
    private_constant(:ESC, :PI2_THIRD, :PI4_THIRD, :NAMED_COLORS)
  end
end

require_relative 'ansi/attributes'
require_relative 'ansi/constants'
