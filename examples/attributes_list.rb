# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h2 'NattyUI: All Attributes and Basic Colors', space: 2

ui.ls(
  (NattyUI::Ansi.attribute_names + NattyUI::Ansi.color_names)
    .sort!
    .map! { |name| "[#{name}]#{name}" }
)
ui.space
