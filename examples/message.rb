# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: Message Types'
ui.space

TEXT = <<~TEXT.tr("\n", ' ')
  Lorem [[yellow]]ipsum[[/]] dolor sit amet, consectetur adipisicing elit, sed
  do eiusmod tempor incididunt ut labore et dolore [[red]]magna[[/]] aliqua.
  Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
  aliquip ex ea commodo [[bold]]consequat[[/]].
TEXT

IMPORTANT =
  '[[red]]>>>[[/]] [[italic]]Here some important information[[/]] [[red]]<<<'

ui.framed do
  ui.info 'Informative Message', TEXT
  ui.warning 'Warning Message' do
    ui.puts TEXT
    ui.framed(type: :double) { ui.puts IMPORTANT }
  end
  ui.error 'Error Message', TEXT
  ui.failed 'Fail Message', TEXT
  ui.message '[[italic #fad]]Custom Message', TEXT, glyph: '💡'
end

ui.space
