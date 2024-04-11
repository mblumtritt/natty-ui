# frozen_string_literal: true

module NattyUI
  #
  # Helper module for ANSI escape codes.
  #
  module Ansi
    # ANSI code to move the cursor down.
    CURSOR_DOWN = "\e[B"

    # ANSI code to move the cursor up.
    CURSOR_UP = "\e[A"

    # ANSI code to move the cursor left.
    CURSOR_LEFT = "\e[D"

    # ANSI code to move the cursor right.
    CURSOR_RIGHT = "\e[C"

    # ANSI code to move the cursor to beginning of the line below.
    CURSOR_LINE_DOWN = "\e[E"

    # ANSI code to move the cursor to beginning of the line up.
    CURSOR_LINE_UP = "\e[F"

    # ANSI code to hide the cursor.
    CURSOR_HIDE = "\e[?25l"

    # ANSI code to show the cursor (again).
    CURSOR_SHOW = "\e[?25h"

    # ANSI code to save current cursor position.
    CURSOR_SAVE_POS = "\e[s"

    # ANSI code to restore saved cursor position.
    CURSOR_RESTORE_POS = "\e[u"

    # ANSI code to set cursor position on upper left corner.
    CURSOR_HOME = "\e[H"

    # ANSI code to erase current line and position to first column.
    LINE_CLEAR = "\e[1K\e[0G"

    # ANSI code to erase current line.
    LINE_ERASE = "\e[2K"

    # ANSI code to erase to end of current line.
    LINE_ERASE_TO_END = "\e[0K"

    # ANSI code to erase to begin of current line.
    LINE_ERASE_TO_BEGIN = "\e[1K"

    # ANSI code to save current screen state.
    SCREEN_SAVE = "\e[?47h"

    # ANSI code to restore screen state.
    SCREEN_RESTORE = "\e[?47l"

    # ANSI code to erase screen.
    SCREEN_ERASE = "\e[2J"

    # ANSI code to erase screen below current cursor position.
    SCREEN_ERASE_BELOW = "\e[0J"

    # ANSI code to erase screen above current cursor position.
    SCREEN_ERASE_ABOVE = "\e[1J"

    # ANSI code to alternate screen
    SCREEN_ALTERNATIVE = "\e[?1049h"

    # ANSI code to set alternate screen off.
    SCREEN_ALTERNATIVE_OFF = "\e[?1049l"

    # ANSI code to reset all attributes.
    RESET = "\e[0m"

    # @!visibility private
    CURSOR_RIGHT_ALIGNED = "\e[9999G\e[D\e[C"

    # @!visibility private
    BLANK_SLATE = "\e[0m\e[s\e[?47h\e[H\e[2J"

    # @!visibility private
    UNBLANK_SLATE = "\e[?47l\e[u\e[0m"

    class << self
      # @deprecated Please use {RESET} instead.
      # @return [String] ANSI code to reset all attributes
      def reset = "\e[0m"

      # @deprecated Please use {SCREEN_SAVE} instead.
      # @return [String] ANSI code to save current screen state
      def screen_save = "\e[?47h"

      # @deprecated Please use {SCREEN_RESTORE} instead.
      # @return [String] ANSI code to restore screen state
      def screen_restore = "\e[?47l"

      # @deprecated Please use {SCREEN_ALTERNATIVE} instead.
      # @return [String] ANSI code to alternate screen
      def screen_alternative = "\e[?1049h"

      # @deprecated Please use {SCREEN_ALTERNATIVE_OFF} instead.
      # @return [String] ANSI code to set alternate screen off
      def screen_alternative_off = "\e[?1049l"

      # @deprecated Please use {SCREEN_ERASE} instead.
      # @return [String] ANSI code to erase screen
      def screen_erase = "\e[2J"

      # @deprecated Please use {SCREEN_ERASE_BELOW} instead.
      # @return [String] ANSI code to erase screen below current cursor position
      def screen_erase_below = "\e[0J"

      # @deprecated Please use {SCREEN_ERASE_ABOVE} instead.
      # @return [String] ANSI code to erase screen above current cursor position
      def screen_erase_above = "\e[1J"

      # @deprecated Please use {LINE_ERASE} instead.
      # @return [String] ANSI code to erase current line
      def line_erase = "\e[2K"

      # @deprecated Please use {LINE_ERASE_TO_END} instead.
      # @return [String] ANSI code to erase to end of current line
      def line_erase_to_end = "\e[0K"

      # @deprecated Please use {LINE_ERASE_TO_BEGIN} instead.
      # @return [String] ANSI code to erase to begin of current line
      def line_erase_to_begin = "\e[1K"

      # @deprecated Please use {LINE_CLEAR} instead.
      # @return [String] ANSI code to erase current line and position to first
      #   column
      def line_clear = "\e[1K\e[0G"

      # @deprecated Please use {CURSOR_RIGHT_ALIGNED} instead.
      # @return [String] ANSI code positioning the cursor on right hand side of
      #   the terminal
      def cursor_right_aligned = "\e[9999G\e[D\e[C"

      # @deprecated Please use {CURSOR_HIDE} instead.
      # @return [String] ANSI code to hide the cursor
      def cursor_hide = "\e[?25l"

      # @deprecated Please use {CURSOR_SHOW} instead.
      # @return [String] ANSI code to show the cursor (again)
      def cursor_show = "\e[?25h"

      # @deprecated Please use {CURSOR_SAVE_POS} instead.
      # @return [String] ANSI code to save current cursor position
      def cursor_save_pos = "\e[s"

      # @deprecated Please use {CURSOR_RESTORE_POS} instead.
      # @return [String] ANSI code to restore saved cursor position
      def cursor_restore_pos = "\e[u"

      # @deprecated Please use {CURSOR_HOME} instead.
      # @return [String] ANSI code to set cursor position on upper left corner
      def cursor_home = "\e[H"

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
      # @return [String] ANSI code to move the cursor to beginning of some lines
      #   below
      def cursor_line_down(lines = nil) = "\e[#{lines}E"

      # @param lines [Integer] number of lines
      # @return [String] ANSI code to move the cursor to beginning of some lines
      #   up
      def cursor_line_up(lines = nil) = "\e[#{lines}F"

      # @param column [Integer] column number
      # @return [String] ANSI code to move the cursor to given column
      def cursor_column(column = nil) = "\e[#{column}G"

      # @param row [Integer] row to set cursor
      # @param column [Integer] column to set cursor
      # @return [String] ANSI code to set cursor position
      def cursor_pos(row, column = nil)
        return column ? "\e[#{row};#{column}H" : "\e[#{row}H" if row
        column ? "\e[;#{column}H" : "\e[H"
      end

      # Decorate given `str` with ANSI `attributes`.
      #
      # @see []
      #
      # @param str [#to_s] object to be decorated
      # @param attributes [Symbol, String] attribute names to be used
      # @param reset [Boolean] whether to include reset code for ANSI attributes
      # @return [String] `str` converted and decorated with the ANSI `attributes`
      def embellish(str, *attributes, reset: true)
        attributes = self[*attributes]
        attributes.empty? ? str.to_s : "#{attributes}#{str}#{"\e[0m" if reset}"
      end

      # Remove ANSI attribtes from given string.
      #
      # @see embellish
      #
      # @param str [#to_s] string to be modified
      # @return [String] string without ANSI attributes
      def blemish(str) = str.to_s.gsub(/(\x1b\[(?~[a-zA-Z])[a-zA-Z])/, '')

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
      # `encircled_off`, `overlined_off`.
      #
      # Colors can specified by their name for ANSI 3-bit and 4-bit colors:
      # `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`,
      # `default`, `bright_black`, `bright_red`, `bright_green`,
      # `bright_yellow`, `bright_blue`, `bright_magenta`, `bright_cyan`,
      # `bright_white`.
      #
      # For 8-bit ANSI colors use 2-digit hexadecimal values `00`...`ff`.
      #
      # To use RGB ANSI colors (24-bit colors) specify 3-digit or 6-digit
      # hexadecimal values `000`...`fff` or `000000`...`ffffff`.
      # This represent the `RRGGBB` values (or `RGB` for short version) like you
      # may known from CSS color notation.
      #
      # To use a color as background color prefix the color attribute with `bg_`
      # or `on_`.
      #
      # To use a color as underline color prefix the color attribute with `ul_`.
      #
      # To make it more clear a color attribute have to be used as foreground
      # color the color value can be prefixed with `fg_`.
      #
      # @example Valid Foreground Color Attributes
      #   Ansi[:yellow]
      #   Ansi['#fab']
      #   Ansi['#00aa00']
      #   Ansi[:fg_fab]
      #   Ansi[:fg_00aa00]
      #   Ansi[:af]
      #   Ansi[:fg_af]
      #
      # @example Valid Background Color Attributes
      #   Ansi[:bg_yellow]
      #   Ansi[:bg_fab]
      #   Ansi[:bg_00aa00]
      #   Ansi['bg#00aa00']
      #   Ansi[:bg_af]
      #
      #   Ansi[:on_yellow]
      #   Ansi[:on_fab]
      #   Ansi[:on_00aa00]
      #   Ansi['on#00aa00']
      #   Ansi[:on_af]
      #
      # @example Valid Underline Color Attributes
      #   Ansi[:underline, :ul_yellow]
      #   Ansi[:underline, :ul_fab]
      #   Ansi[:underline, :ul_00aa00]
      #   Ansi[:underline, 'ul#00aa00']
      #   Ansi[:underline, :ul_fa]
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
                ATTRIBUTES[arg] || color(arg) || invalid_argument(arg)
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
        return if (attributes = attributes.to_s.split).empty?
        "\e[#{
          attributes.map { ATTRIBUTES[_1] || color(_1) || return }.join(';')
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

      def color(val)
        val = val.to_s.downcase
        base =
          if val.delete_prefix!('fg')
            val.delete_prefix!(':') || val.delete_prefix!('_')
            '38;'
          elsif val.delete_prefix!('ul')
            val.delete_prefix!(':') || val.delete_prefix!('_')
            '58;'
          elsif val.delete_prefix!('bg') || val.delete_prefix!('on')
            val.delete_prefix!(':') || val.delete_prefix!('_')
            '48;'
          else
            '38;'
          end
        val.delete_prefix!('#')
        case val.size
        when 2
          "#{base}5;#{val.hex}" if /\A[[:xdigit:]]+\z/.match?(val)
        when 3
          if /\A[[:xdigit:]]+\z/.match?(val)
            "#{base}2;#{(val[0] * 2).hex};#{(val[1] * 2).hex};#{
              (val[2] * 2).hex
            }"
          end
        when 6
          if /\A[[:xdigit:]]+\z/.match?(val)
            "#{base}2;#{val[0, 2].hex};#{val[2, 2].hex};#{val[4, 2].hex}"
          end
        end
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
      }.tap { _1.merge!(_1.transform_keys(&:to_s)).freeze }
    private_constant :ATTRIBUTES
  end
end
