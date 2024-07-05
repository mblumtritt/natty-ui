# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: Print In Columns'
ui.space

LOREM = <<~IPSUM.lines(chomp: true)
  Lorem ipsum dolor sit
  amet, consectetur adipisicing
  elit, sed do eiusmod tempor
  incididunt ut labore et
  dolore [[red]]magna[[/]] aliqua. Ut
  enim ad minim veniam, quis
  nostrud exercitation ullamco
  laboris nisi ut aliquip ex
  ea commodo [[bold]]consequat[[/]]. Duis
  aute irure [[bold green]]dolor[[/]] in
  reprehenderit in voluptate
  velit [[underline]]esse cillum[[/]] dolore eu
  fugiat nulla pariatur.
  Excepteur sint occaecat
  cupidatat non proident,
  sunt in culpa qui officia
  deserunt mollit anim id
  est laborum.
IPSUM

ui.h2 'Compact Display'
ui.ls LOREM, glyph: 1
ui.space

ui.h2 'Traditional Display'
ui.ls LOREM, glyph: 1, compact: false
ui.space
