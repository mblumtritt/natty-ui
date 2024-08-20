# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h2 'NattyUI: All Named Colors', space: 2

list =
  NattyUI::Ansi.named_colors.map! do |name|
    "[on_#{name}] [/bg] [#{name}]#{name}[/fg]"
  end

ui.ls list
ui.space
