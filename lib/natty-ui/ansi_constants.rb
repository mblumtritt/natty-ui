# frozen_string_literal: true

module NattyUI
  module Ansi
    CURSOR_SHOW = "\e[?25h"
    CURSOR_HIDE = "\e[?25l"
    CURSOR_HOME = cursor_pos(nil, nil)
    CURSOR_FIRST_ROW = cursor_pos(1).freeze
    CURSOR_FIRST_COLUMN = cursor_column(1).freeze
    CURSOR_SAFE_POS_SCO = "\e[s"
    CURSOR_RESTORE_POS_SCO = "\e[u"
    CURSOR_SAFE_POS_DEC = "\e7"
    CURSOR_RESTORE_POS_DEC = "\e8"
    CURSOR_SAFE_POS = CURSOR_SAFE_POS_DEC
    CURSOR_RESTORE_POS = CURSOR_RESTORE_POS_DEC

    CURSOR_ALIGN_RIGHT = "\e[9999G\e[1D\e[1C" # @!visibility private

    SCREEN_ERASE = screen_erase(:entire)
    SCREEN_SAVE = "\e[?47h"
    SCREEN_RESTORE = "\e[?47l"
    SCREEN_ALTERNATE = "\e[?1049h"
    SCREEN_ALTERNATE_OFF = "\e[?1049l"
    SCREEN_SAVE_ATTRIBUTES = '\e[#{'
    SCREEN_RESTORE_ATTRIBUTES = '\e[#}'

    SCREEN_BLANK = "\e[0m\e[s\e[?47h\e[H\e[2J" # @!visibility private
    SCREEN_UNBLANK = "\e[?47l\e[u\e[0m" # @!visibility private

    LINE_PREVIOUS = cursor_previous_line(1).freeze
    LINE_NEXT = cursor_next_line(1).freeze
    LINE_ERASE = line_erase(:entire)

    # ANSI control code sequence to erase the screen and set cursor position on
    # upper left corner.
    CLS = (CURSOR_HOME + SCREEN_ERASE).freeze

    # ANSI control code sequence to erase current line and position to first
    # column.
    CLL = (LINE_ERASE + CURSOR_FIRST_COLUMN).freeze

    # ANSI control code to reset all attributes.
    RESET = self[:reset].freeze

    BOLD = self[:bold].freeze
    BOLD_OFF = self[:bold_off].freeze

    FAINT = self[:faint].freeze
    FAINT_OFF = self[:faint_off].freeze

    ITALIC = self[:italic].freeze
    ITALIC_OFF = self[:italic_off].freeze

    STRIKE = self[:strike].freeze
    STRIKE_OFF = self[:strike_off].freeze

    UNDERLINE = self[:underline].freeze
    DOUBLE_UNDERLINE = self[:double_underline].freeze
    UNDERLINE_OFF = self[:underline_off].freeze

    CURLY_UNDERLINE = self[:curly_underline].freeze
    CURLY_UNDERLINE_OFF = self[:curly_underline_off].freeze

    BLINK = self[:blink].freeze
    BLINK_OFF = self[:blink_off].freeze

    INVERT = self[:invert].freeze
    INVERT_OFF = self[:invert_off].freeze

    HIDE = self[:hide].freeze
    REVEAL = self[:reveal].freeze
  end
end
