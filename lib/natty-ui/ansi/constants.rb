# frozen_string_literal: true

module NattyUI::Ansi
  CURSOR_SHOW = "\e[?25h"
  CURSOR_HIDE = "\e[?25l"

  CURSOR_HOME = cursor_pos(nil, nil)
  CURSOR_FIRST_ROW = cursor_pos(1).freeze
  CURSOR_FIRST_COLUMN = cursor_column(1).freeze

  CURSOR_SAFE_POS_SCO = "\e[s"
  CURSOR_SAFE_POS_DEC = "\e7"
  CURSOR_SAFE_POS = CURSOR_SAFE_POS_DEC

  CURSOR_RESTORE_POS_SCO = "\e[u"
  CURSOR_RESTORE_POS_DEC = "\e8"
  CURSOR_RESTORE_POS = CURSOR_RESTORE_POS_DEC

  SCREEN_ERASE = screen_erase(:entire)

  SCREEN_SAVE = "\e[?47h"
  SCREEN_RESTORE = "\e[?47l"

  SCREEN_ALTERNATE = "\e[?1049h"
  SCREEN_ALTERNATE_OFF = "\e[?1049l"

  LINE_PREVIOUS = cursor_previous_line(1).freeze
  LINE_NEXT = cursor_next_line(1).freeze
  LINE_ERASE = line_erase(:entire)

  RESET = self[:reset].freeze

  BOLD = self[:bold].freeze
  BOLD_OFF = self[:bold].freeze

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

  # @!visibility private
  CLS = "#{CURSOR_HOME}#{SCREEN_ERASE}".freeze

  # @!visibility private
  CLL = "#{CURSOR_FIRST_COLUMN}#{LINE_ERASE}".freeze

  # @!visibility private
  SCREEN_BLANK =
    "#{CURSOR_SAFE_POS}#{
      SCREEN_ALTERNATE
    }#{CURSOR_HOME}#{SCREEN_ERASE}#{RESET}".freeze

  # @!visibility private
  SCREEN_UNBLANK = "#{RESET}#{SCREEN_ALTERNATE_OFF}#{CURSOR_RESTORE_POS}".freeze
end
