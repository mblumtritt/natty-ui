# frozen_string_literal: true

module NattyUI
  #
  # Helper module for ANSI escape codes.
  #
  module Ansi
    class << self
      # Supported attribute names.
      # @see []
      #
      # @attribute [r] attribute_names
      # @return [Array<Symbol>] all attribute names
      def attribute_names = SATTR.keys

      # Supported basic color names.
      # @see []
      #
      # @attribute [r] color_names
      # @return [Array<Symbol>] all basic color names
      def color_names = SCLR.keys

      # Defined named colors (24bit colors).
      #
      # *Remark*: Named colors follow the same name schema and color palette
      # as supported by Kitty.
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
                SATTR[arg] || SCLR[arg] || color(arg.to_s) ||
                  invalid_argument(arg)
              when String
                ATTR[arg] || CLR[arg] || color(arg) || invalid_argument(arg)
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
        attributes.empty? ? str.to_s : "#{attributes}#{str}#{"\e[0m" if reset}"
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
            .map! { ATTR[_1] || CLR[_1] || color(_1) || return }
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

      def color(val)
        base = CLR_PREFIX[val[0, 2]]
        idx = base ? 2 : 0
        base ||= '38'
        idx += 1 if val[idx] == '_' || val[idx] == ':'
        idx += 1 if val[idx] == '#'
        val = val[idx..]
        return "#{base};5;#{val.hex}" if /\A[[:xdigit:]]{1,2}\z/.match?(val)
        if /\A[[:xdigit:]]{6}\z/.match?(val)
          return "#{base};2;#{val[0, 2].hex};#{val[2, 2].hex};#{val[4, 2].hex}"
        end
        if /\A[[:xdigit:]]{3}\z/.match?(val)
          return(
            "#{base};2;#{(val[0] * 2).hex};#{
              (val[1] * 2).hex
            };#{(val[2] * 2).hex}"
          )
        end
        code = NAMED_COLORS[val] and return "#{base};#{code}"
      end
    end

    # @!visibility private
    CSI = /\e\[[\d;:]*[ABCDEFGHJKSTfminsuhl]/

    # @!visibility private
    OSC = /\e\]\d+(?:;[^;\a\e]+)*(?:\a|\e\\)/

    ESC = /(#{CSI})|(#{OSC})/

    CLR_PREFIX = {
      'fg' => '38',
      'bg' => '48',
      'ul' => '58',
      'on' => '48'
    }.freeze

    PI2_THIRD = 2 * Math::PI / 3
    PI4_THIRD = 4 * Math::PI / 3

    ATTR =
      Module
        .new do
          def self.to_hash
            map = {
              'reset' => '',
              # "new underline"
              'curly_underline_off' => '4:0',
              # 'underline' => '4:1',
              # 'double_underline' => '4:2',
              'curly_underline' => '4:3',
              'dotted_underline' => '4:4',
              'dashed_underline' => '4:5'
            }
            add = ->(s, n) { n.each_with_index { |a, idx| map[a] = s + idx } }
            add[
              1,
              %w[
                bold
                faint
                italic
                underline
                blink
                rapid_blink
                invert
                hide
                strike
                primary_font
                font1
                font2
                font3
                font4
                font5
                font6
                font7
                font8
                font9
                fraktur
                double_underline
                bold_off
                italic_off
                underline_off
                blink_off
                proportional
                invert_off
                hide_off
                strike_off
              ]
            ]
            add[
              50,
              %w[
                proportional_off
                framed
                encircled
                overlined
                framed_off
                overlined_off
              ]
            ]
            add[73, %w[superscript subscript superscript_off]]

            map['dashed_underline_off'] = map['curly_underline_off']
            map['default_font'] = map['primary_font']
            map['dotted_underline_off'] = map['curly_underline_off']
            map['double_underline_off'] = map['underline_off']
            map['encircled_off'] = map['framed_off']
            map['faint_off'] = map['bold_off']
            map['fraktur_off'] = map['italic_off']
            map['reveal'] = map['hide_off']
            map['subscript_off'] = map['superscript_off']

            add_alias =
              proc do |name, org_name|
                map[name] = map[org_name]
                map["/#{name}"] = map["#{org_name}_off"]
              end
            add_alias['b', 'bold']
            add_alias['conceal', 'hide']
            add_alias['cu', 'curly_underline']
            add_alias['dau', 'dashed_underline']
            add_alias['dim', 'faint']
            add_alias['dou', 'dotted_underline']
            add_alias['h', 'hide']
            add_alias['i', 'italic']
            add_alias['inv', 'invert']
            add_alias['ovr', 'overlined']
            add_alias['slow_blink', 'blink']
            add_alias['spacing', 'proportional']
            add_alias['sub', 'subscript']
            add_alias['sup', 'superscript']
            add_alias['u', 'underline']
            add_alias['uu', 'double_underline']

            map.merge!(
              map
                .filter_map do |name, att|
                  if name.end_with?('_off')
                    ["/#{name.delete_suffix('_off')}", att]
                  end
                end
                .to_h
            )
          end
        end
        .to_hash
        .freeze

    CLR =
      Module
        .new do
          def self.to_hash
            clr = {
              0 => 'black',
              1 => 'red',
              2 => 'green',
              3 => 'yellow',
              4 => 'blue',
              5 => 'magenta',
              6 => 'cyan',
              7 => 'white'
            }
            map = {}
            add = ->(s, p) { clr.each_pair { |i, n| map["#{p}#{n}"] = s + i } }
            ul = ->(r, g, b) { "58;2;#{r};#{g};#{b}" }
            add[30, nil]
            map['default'] = 39
            add[90, 'bright_']
            add[30, 'fg_']
            map['fg_default'] = 39
            map['/fg'] = 39
            add[90, 'fg_bright_']
            add[40, 'bg_']
            map['bg_default'] = 49
            map['/bg'] = 49
            add[100, 'bg_bright_']
            add[40, 'on_']
            map['on_default'] = 49
            add[100, 'on_bright_']
            map.merge!(
              'ul_black' => ul[0, 0, 0],
              'ul_red' => ul[128, 0, 0],
              'ul_green' => ul[0, 128, 0],
              'ul_yellow' => ul[128, 128, 0],
              'ul_blue' => ul[0, 0, 128],
              'ul_magenta' => ul[128, 0, 128],
              'ul_cyan' => ul[0, 128, 128],
              'ul_white' => ul[128, 128, 128],
              'ul_default' => '59',
              '/ul' => '59',
              'ul_bright_black' => ul[64, 64, 64],
              'ul_bright_red' => ul[255, 0, 0],
              'ul_bright_green' => ul[0, 255, 0],
              'ul_bright_yellow' => ul[255, 255, 0],
              'ul_bright_blue' => ul[0, 0, 255],
              'ul_bright_magenta' => ul[255, 0, 255],
              'ul_bright_cyan' => ul[0, 255, 255],
              'ul_bright_white' => ul[255, 255, 255]
            )
          end
        end
        .to_hash
        .freeze

    SATTR =
      ATTR.to_a.sort!.to_h.transform_keys!(&:to_sym).compare_by_identity.freeze
    SCLR =
      CLR.to_a.sort!.to_h.transform_keys!(&:to_sym).compare_by_identity.freeze

    autoload(:NAMED_COLORS, File.join(__dir__, 'ansi', 'named_colors'))

    private_constant(
      :ESC,
      :CLR_PREFIX,
      :PI2_THIRD,
      :PI4_THIRD,
      :SATTR,
      :CLR,
      :ATTR,
      :SCLR,
      :NAMED_COLORS
    )
  end
end

require_relative 'ansi/constants'
