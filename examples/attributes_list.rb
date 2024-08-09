# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h2 'NattyUI: All Attribute and Defined Color Names'
ui.space

ui.ls(
  (NattyUI::Ansi.attribute_names + NattyUI::Ansi.color_names)
    .sort!
    .map! { |name| "[#{name}]#{name}" }
)
ui.space
