# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: Message Types', space: 2

TEXT = <<~TEXT.tr("\n", ' ')
  Lorem [yellow]ipsum[/fg] dolor sit amet, consectetur adipisicing elit, sed
  do eiusmod tempor incididunt ut labore et dolore [red]magna[/fg] aliqua.
  Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
  aliquip ex ea commodo [b]consequat[/b].
TEXT

ui.framed do
  ui.info 'Informative Message', TEXT
  ui.warning 'Warning Message' do
    ui.framed(type: :double) do
      ui.puts(
        '[red]>>>[/fg] [i]Important information maybe here[/i] [red]<<<',
        align: :center
      )
    end
    ui.puts('[i f4]Ut enim ad minim veniam', align: :right)
  end
  ui.error 'Error Message', TEXT
  ui.failed 'Fail Message', TEXT
  ui.message '[i #fad]Custom Message', TEXT, glyph: '💡'
end

ui.space
