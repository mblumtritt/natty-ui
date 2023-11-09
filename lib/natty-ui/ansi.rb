# frozen_string_literal: true

module NattyUI
  #
  # Helper module for ANSI escape codes.
  #
  module Ansi
    class << self
      # @return [String] ANSI code to reset all attributes
      def reset = "\e[0m"

      # @return [String] ANSI code to save current screen state
      def screen_save = "\e[?47h"

      # @return [String] ANSI code to restore screen state
      def screen_restore = "\e[?47l"

      # @return [String] ANSI code to alternate screen
      def screen_alternative = "\e[?1049h"

      # @return [String] ANSI code to set alternate screen off
      def screen_alternative_off = "\e[?1049l"

      # @return [String] ANSI code to erase screen
      def screen_erase = "\e[2J"

      # @return [String] ANSI code to erase screen below current cursor position
      def screen_erase_below = "\e[0J"

      # @return [String] ANSI code to erase screen above current cursor position
      def screen_erase_above = "\e[1J"

      # @return [String] ANSI code to erase current line
      def line_erase = "\e[2K"

      # @return [String] ANSI code to erase to end of current line
      def line_erase_to_end = "\e[0K"

      # @return [String] ANSI code to erase to begin of current line
      def line_erase_to_begin = "\e[1K"

      # @return [String] ANSI code to erase current line and position to first
      #   column
      def line_clear = "\e[1K\e[0G"

      # @param lines [Integer] number of lines
      # @return [String] ANSI code to move the cursor up
      def cursor_up(lines = nil) = "\e[#{lines}A"

      # @param lines [Integer] number of lines
      # @return [String] ANSI code to move the cursor down
      def cursor_down(lines = nil) = "\e[#{lines}B"

      # @param columns [Integer] number of columns
      # @return [String] ANSI code to move the cursor right
      def cursor_right(columns = nil) = "\e[#{columns}C"

      # @param columns [Integer] number of columns
      # @return [String] ANSI code to move the cursor left
      def cursor_left(columns = nil) = "\e[#{columns}D"

      # @param lines [Integer] number of lines
      # @return [String] ANSI code to move the cursor to beginning of the line some lines down
      def cursor_line_down(lines = nil) = "\e[#{lines}E"

      # @param lines [Integer] number of lines
      # @return [String] ANSI code to move the cursor to beginning of the line some lines up
      def cursor_line_up(lines = nil) = "\e[#{lines}F"

      # @param columns [Integer] number of columns
      # @return [String] ANSI code to move the cursor to giben column
      def cursor_column(columns = nil) = "\e[#{columns}G"

      # @return [String] ANSI code to hide the cursor
      def cursor_hide = "\e[?25l"

      # @return [String] ANSI code to show the cursor (again)
      def cursor_show = "\e[?25h"

      # @return [String] ANSI code to save current cursor position
      def cursor_save_pos = "\e[s"

      # @return [String] ANSI code to restore saved cursor position
      def cursor_restore_pos = "\e[u"

      # @return [String] ANSI code to set cursor position on upper left corner
      def cursor_home = "\e[H"

      # @param row [Integer] row to set cursor
      # @param column [Integer] column to set cursor
      # @return [String] ANSI code to set cursor position
      def cursor_pos(row, column = nil)
        return column ? "\e[#{row};#{column}H" : "\e[#{row}H" if row
        column ? "\e[;#{column}H" : "\e[H"
      end

      # Decorate given `obj` with ANSI `attributes`.
      #
      # @see []
      #
      # @param obj [#to_s] object to be decorated
      # @param attributes [Symbol, String] attribute names to be used
      # @param reset [Boolean] whether to include reset code for ANSI attributes
      # @return [String] `obj` converted and decorated with the ANSI `attributes`
      def embellish(obj, *attributes, reset: true)
        attributes = self[*attributes]
        attributes.empty? ? "#{obj}" : "#{attributes}#{obj}#{"\e[0m" if reset}"
      end

      # Combine given ANSI `attributes`.
      #
      # ANSI attribute names are:
      #
      # `reset`, `bold`, `faint`, `italic`, `underline`, `slow_blink`, `blink`,
      # `rapid_blink`, `invert`, `reverse`, `conceal`, `hide`, `strike`,
      # `primary_font`, `default_font`, `font1`, `font2`, `font3`, `font4`,
      # `font5`, `font6`, `font7`, `font8`, `font9`, `fraktur`,
      # `double_underline`, `doubly`, `bold_off`, `normal`, `italic_off`,
      # `fraktur_off`, `underline_off`, `blink_off`, `proportional`, `spacing`,
      # `invert_off`, `reverse_off`, `reveal`, `strike_off`, `proportional_off`,
      # `spacing_off`, `framed`, `encircled`, `overlined`, `framed_off`,
      # `encircled_off`, `overlined_off`
      #
      # Colors can specified by their name for ANSI 4-bit colors:
      # `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`,
      # `default`, `bright_black`, `bright_red`, `bright_green`, `bright_yellow`,
      # `bright_blue`, `bright_magenta`, `bright_cyan`, `bright_white`
      #
      # For 8-bit ANSI colors you can use a prefixed integer number:
      # `i0`...`i255`.
      #
      # To use RGB ANSI colors just specify the hexadecimal code like `#XXXXXX`
      # or the short form `#XXX`.
      #
      # To use a color as background color prefix the color attribute with `bg_`
      # or `on_`.
      #
      # To use a color as underline color prefix the color attribute with `ul_`.
      #
      # To make it more clear a color attribute should be used as fereground
      # color the code can be prefixed with `fg_`.
      #
      # @example Valid Foreground Color Attributes
      #   Ansi[:yellow]
      #   Ansi["#fab"]
      #   Ansi["#00aa00"]
      #   Ansi[:fg_fab]
      #   Ansi[:fg_00aa00]
      #   Ansi[:i196]
      #   Ansi[:fg_i196]
      #
      # @example Valid Background Color Attributes
      #   Ansi[:bg_yellow]
      #   Ansi[:bg_fab]
      #   Ansi[:bg_00aa00]
      #   Ansi['bg#00aa00']
      #   Ansi[:bg_i196]
      #
      #   Ansi[:on_yellow]
      #   Ansi[:on_fab]
      #   Ansi[:on_00aa00]
      #   Ansi['on#00aa00']
      #   Ansi[:on_i196]
      #
      # @example Valid Underline Color Attributes
      #   Ansi[:underline, :yellow]
      #   Ansi[:underline, :ul_fab]
      #   Ansi[:underline, :ul_00aa00]
      #   Ansi[:underline, 'ul#00aa00']
      #   Ansi[:underline, :ul_i196]
      #   Ansi[:underline, :ul_bright_yellow]
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
              when Symbol, String
                ATTRIBUTES[arg] || named_color(arg) || invalid_argument(arg)
              when (0..255)
                "38;5;#{arg}"
              when (256..512)
                "48;5;#{arg}"
              else
                invalid_argument(arg)
              end
            end
            .join(';')
        }m"
      end

      # Try to combine given ANSI `attributes`. The `attributes` have to be a
      # string containing attributes separated by space char (" ").
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
        attributes = attributes.to_s.split
        return if attributes.empty?
        "\e[#{
          attributes
            .map { |arg| ATTRIBUTES[arg] || named_color(arg) || return }
            .join(';')
        }m"
      end

      private

      def invalid_argument(name)
        raise(
          ArgumentError,
          "unknown Ansi attribute name - '#{name}'",
          caller(1)
        )
      end

      def named_color(value)
        case value
        when /\A(fg_|fg:|fg)?#?([[:xdigit:]]{3})\z/
          hex_rgb_short(38, Regexp.last_match(2))
        when /\A(fg_|fg:|fg)?#?([[:xdigit:]]{6})\z/
          hex_rgb(38, Regexp.last_match(2))
        when /\A(bg_|bg:|bg|on_|on:|on)#?([[:xdigit:]]{3})\z/
          hex_rgb_short(48, Regexp.last_match(2))
        when /\A(bg_|bg:|bg|on_|on:|on)#?([[:xdigit:]]{6})\z/
          hex_rgb(48, Regexp.last_match(2))
        when /\A(ul_|ul:|ul)#?([[:xdigit:]]{3})\z/
          hex_rgb_short(58, Regexp.last_match(2))
        when /\A(ul_|ul:|ul)#?([[:xdigit:]]{6})\z/
          hex_rgb(58, Regexp.last_match(2))
        when /\A(fg_|fg:|fg)?i([[:digit:]]{1,3})\z/
          number(38, Regexp.last_match(2))
        when /\A(bg_|bg:|bg|on_|on:|on)i([[:digit:]]{1,3})\z/
          number(48, Regexp.last_match(2))
        when /\A(ul_|ul:|ul)i([[:digit:]]{1,3})\z/
          number(58, Regexp.last_match(2))
        end
      end

      def number(base, str)
        index = str.to_i
        "#{base};5;#{index}" if index >= 0 && index <= 255
      end

      def hex_rgb_short(base, str)
        "#{base};2;#{(str[0] * 2).hex};#{(str[1] * 2).hex};#{(str[2] * 2).hex}"
      end

      def hex_rgb(base, str)
        "#{base};2;#{str[0, 2].hex};#{str[2, 2].hex};#{str[4, 2].hex}"
      end
    end

    ATTRIBUTES =
      {
        reset: 0,
        # ---
        bold: 1,
        faint: 2,
        italic: 3,
        underline: 4,
        # ---
        slow_blink: 5,
        blink: 5,
        # ---
        rapid_blink: 6,
        # ---
        invert: 7,
        reverse: 7,
        # ---
        conceal: 8,
        hide: 8,
        # ---
        strike: 9,
        # ---
        primary_font: 10,
        default_font: 10,
        # ---
        font1: 11,
        font2: 12,
        font3: 13,
        font4: 14,
        font5: 15,
        font6: 16,
        font7: 17,
        font8: 18,
        font9: 19,
        fraktur: 20,
        # ---
        double_underline: 21,
        doubly: 21,
        bold_off: 21,
        # ---
        normal: 22,
        # ---
        italic_off: 23,
        fraktur_off: 23,
        # ---
        underline_off: 24,
        blink_off: 25,
        # ---
        proportional: 26,
        spacing: 26,
        # ---
        invert_off: 27,
        reverse_off: 27,
        # ---
        reveal: 28,
        # ---
        strike_off: 29,
        # ---
        proportional_off: 50,
        spacing_off: 50,
        # ---
        framed: 51,
        encircled: 52,
        overlined: 53,
        framed_off: 54,
        encircled_off: 54,
        overlined_off: 55,
        # foreground colors
        black: 30,
        red: 31,
        green: 32,
        yellow: 33,
        blue: 34,
        magenta: 35,
        cyan: 36,
        white: 37,
        default: 39,
        bright_black: 90,
        bright_red: 91,
        bright_green: 92,
        bright_yellow: 93,
        bright_blue: 94,
        bright_magenta: 95,
        bright_cyan: 96,
        bright_white: 97,
        # background colors
        on_black: 40,
        on_red: 41,
        on_green: 42,
        on_yellow: 43,
        on_blue: 44,
        on_magenta: 45,
        on_cyan: 46,
        on_white: 47,
        on_default: 49,
        on_bright_black: 100,
        on_bright_red: 101,
        on_bright_green: 102,
        on_bright_yellow: 103,
        on_bright_blue: 104,
        on_bright_magenta: 105,
        on_bright_cyan: 106,
        on_bright_white: 107,
        # foreground colors
        fg_black: 30,
        fg_red: 31,
        fg_green: 32,
        fg_yellow: 33,
        fg_blue: 34,
        fg_magenta: 35,
        fg_cyan: 36,
        fg_white: 37,
        fg_default: 39,
        fg_bright_black: 90,
        fg_bright_red: 91,
        fg_bright_green: 92,
        fg_bright_yellow: 93,
        fg_bright_blue: 94,
        fg_bright_magenta: 95,
        fg_bright_cyan: 96,
        fg_bright_white: 97,
        # background colors
        bg_black: 40,
        bg_red: 41,
        bg_green: 42,
        bg_yellow: 43,
        bg_blue: 44,
        bg_magenta: 45,
        bg_cyan: 46,
        bg_white: 47,
        bg_default: 49,
        bg_bright_black: 100,
        bg_bright_red: 101,
        bg_bright_green: 102,
        bg_bright_yellow: 103,
        bg_bright_blue: 104,
        bg_bright_magenta: 105,
        bg_bright_cyan: 106,
        bg_bright_white: 107,
        # underline colors
        ul_black: '58;2;0;0;0',
        ul_red: '58;2;128;0;0',
        ul_green: '58;2;0;128;0',
        ul_yellow: '58;2;128;128;0',
        ul_blue: '58;2;0;0;128',
        ul_magenta: '58;2;128;0;128',
        ul_cyan: '58;2;0;128;128',
        ul_white: '58;2;128;128;128',
        ul_default: '59',
        ul_bright_black: '58;2;64;64;64',
        ul_bright_red: '58;2;255;0;0',
        ul_bright_green: '58;2;0;255;0',
        ul_bright_yellow: '58;2;255;255;0',
        ul_bright_blue: '58;2;0;0;255',
        ul_bright_magenta: '58;2;255;0;255',
        ul_bright_cyan: '58;2;0;255;255',
        ul_bright_white: '58;2;255;255;255'
      }.tap { |ret| ret.merge!(ret.transform_keys(&:to_s)).freeze }
    private_constant :ATTRIBUTES
  end
end
