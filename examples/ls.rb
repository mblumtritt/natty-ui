# frozen_string_literal: true

require_relative '../lib/natty-ui'

lorem = <<~IPSUM.lines(chomp: true)
  Lorem ipsum dolor sit amet,
  consectetur adipisicing elit,
  sed do eiusmod tempor
  incididunt ut labore et
  dolore [red]magna[/] aliqua.
  Ut enim ad minim veniam, quis
  nostrud exercitation ullamco
  laboris nisi ut aliquip ex
  ea commodo [b]consequat[/b].
  Duis aute irure [bold green]dolor[/fg] in[/]
  reprehenderit in voluptate
  velit [underline]esse cillum[/] dolore eu
  fugiat nulla pariatur.
  Excepteur sint occaecat
  cupidatat non proident,
  sunt in culpa qui officia
  deserunt mollit anim id
  est laborum.
IPSUM

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Print Lists[/]' do
  ui.space
  ui.h2 'Traditional Display'
  ui.ls lorem, glyph: 1, compact: false

  ui.space
  ui.h2 'Compact Display'
  ui.ls lorem, glyph: 1

  ui.space
  ui.h2 'Latin Char Glyph'
  ui.ls lorem.take(5), glyph: :a

  ui.space
  ui.h2 'Hex Numbers'
  ui.ls lorem.take(5), glyph: '0x08'

  ui.space
  ui.h2 'Chapter Numbering'
  ui.ls lorem.take(5), glyph: :'1.8'

  ui.space
  ui.h2 'Custom Glyph'
  ui.ls lorem.take(5), glyph: '[b bright_yellow]→[/]'
end
