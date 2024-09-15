# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: 24-bit Color Support', space: 2

list =
  NattyUI::Ansi
    .named_colors
    .delete_if { /\d/.match?(_1) }
    .map! { |name| "[on_#{name}]  [/bg] [#{name}]#{name}[/fg]" }

ui.ls list
ui.space
