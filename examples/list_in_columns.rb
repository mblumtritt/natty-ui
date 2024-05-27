# frozen_string_literal: true

require 'natty-ui'

LOREM = <<~LOREM
  Lorem ipsum dolor sit
  amet, consectetur adipisicing
  elit, sed do eiusmod tempor
  incididunt ut labore et
  dolore [[red]]magna[[/]] aliqua. Ut
  enim ad minim veniam, quis
  nostrud exercitation ullamco
  laboris nisi ut aliquip ex
  ea commodo [[bold]]consequat[[/]]. Duis
  aute irure dolor in
  reprehenderit in voluptate
  velit [[underline]]esse cillum[[/]] dolore eu
  fugiat nulla pariatur.
  Excepteur sint occaecat
  cupidatat non proident,
  sunt in culpa qui officia
  deserunt mollit anim id
  est laborum.
LOREM
WORDS = LOREM.split(/\W+/).uniq.sort!.freeze

ui.space
ui.h1 'Print a list in columns'
ui.space

ui.h2 'Lorem ipsum lines'
ui.ls LOREM.lines(chomp: true)
ui.space

ui.h2 'Lorem ipsum word list (compact)'
ui.ls WORDS, glyph: 1
ui.space

ui.h2 'Lorem ipsum word list (row-wise)'
ui.ls WORDS, compact: false, glyph: 1
ui.space
