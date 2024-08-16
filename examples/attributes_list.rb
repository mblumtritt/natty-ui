# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h2 'NattyUI: All Attribute and Defined Color Names', space: 2

ui.ls(
  (NattyUI::Ansi.attribute_names + NattyUI::Ansi.color_names)
    .sort!
    .map! { |name| "[#{name}]#{name}" }
)
ui.space
