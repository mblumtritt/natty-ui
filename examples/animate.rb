# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: Text Line Animation'
ui.space

TEXT = <<~TEXT.tr("\n", ' ')
  Lorem [[yellow]]ipsum[[/]] dolor sit amet, consectetur adipisicing elit, sed
  do eiusmod tempor incididunt ut labore et dolore [[red]]magna[[/]] aliqua.
  Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
  aliquip ex ea commodo [[bold]]consequat[[/]].
TEXT

glyph = '[[27]]◉'

ui.message('Default Animation', glyph: glyph) do
  ui.animate TEXT, animation: :default
end
ui.space

ui.message('Shiny Rainbow', glyph: glyph) do
  ui.animate TEXT, animation: :rainbow
end
ui.space

ui.message('Binary Encoded', glyph: glyph) do
  ui.animate TEXT, animation: :binary, style: 'green', alt_style: :bright_green
end
ui.space

ui.message('Matrix Style', glyph: glyph) { ui.animate TEXT, animation: :matrix }
ui.space

ui.message('Typewriter Like', glyph: glyph) do
  ui.animate TEXT, animation: :type_writer
end
ui.space

ui.message('Default Styled', glyph: glyph) do
  ui.animate TEXT, style: 'bold bright_white on_red'
end
ui.space
