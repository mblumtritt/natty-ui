# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h2 'NattyUI: All Attributes and Basic Colors', space: 2

list =
  (NattyUI::Ansi.attribute_names + NattyUI::Ansi.color_names)
    .sort!
    .map! { |name| "[#{name}]#{name}[/]" }

ui.ls list
ui.space
