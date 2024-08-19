# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h2 'NattyUI: All Names Colors', space: 2

ui.ls(
  NattyUI::Ansi.named_colors.map! do |name|
    "[on_#{name}] [/bg] [#{name}]#{name}"
  end
)
ui.space
