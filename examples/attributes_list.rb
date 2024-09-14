# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h2 'NattyUI: All Attributes and Basic Colors', space: 2

list =
  (NattyUI::Ansi.attributes + NattyUI::Ansi.colors).sort!.map! do |name|
    "[#{name}]#{name}[/]"
  end

ui.ls list
ui.space
