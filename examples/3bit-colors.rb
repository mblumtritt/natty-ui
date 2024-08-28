# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: 3/4-bit Color Support', space: 2

list =
  %w[
    black
    red
    green
    yellow
    blue
    magenta
    cyan
    white
    bright_black
    bright_red
    bright_green
    bright_yellow
    bright_blue
    bright_magenta
    bright_cyan
    bright_white
  ].map! { |name| "[on_#{name}]  [/bg] [#{name}]#{name}[/fg]" }

ui.ls list
ui.space
