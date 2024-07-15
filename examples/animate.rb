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

{
  default: 'Default Animation',
  type_writer: 'Typewriter Like',
  rainbow: 'Shiny Rainbow',
  binary: 'Binary Encoded',
  matrix: 'Matrix Style'
}.each_pair do |type, title|
  ui.message(title, glyph: '[[27]]◉') { ui.animate TEXT, animation: type }
  ui.space
end
