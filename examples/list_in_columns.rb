# frozen_string_literal: true

require 'natty-ui'

UI = NattyUI::StdOut

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

UI.space
UI.h2 'Print a list in columns'
UI.space

UI.h3 'Lorem ipsum lines'
UI.ls LOREM.lines(chomp: true)
UI.space

UI.h3 'Lorem ipsum word list (compact)'
UI.ls WORDS
UI.space

UI.h3 'Lorem ipsum word list (row-wise)'
UI.ls WORDS, compact: false
UI.space
