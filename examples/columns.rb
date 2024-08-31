# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: Print Columns', space: 2

LOREM = <<~IPSUM.lines(chomp: true)
  Lorem ipsum dolor sit
  amet, consectetur adipisicing
  elit, sed do eiusmod tempor
  incididunt ut labore et
  dolore [red]magna[/] aliqua. Ut
  enim ad minim veniam, quis
  nostrud exercitation ullamco
  laboris nisi ut aliquip ex
  ea commodo [b]consequat[/b].
IPSUM

ui.columns(*LOREM, padding: [0, 1], width: :content, frame: :default)

ui.columns do |cc|
  cc.add LOREM[0, 2], align: :left
  cc.add LOREM[2, 2], align: :center
  cc.add LOREM[4, 2], align: :right
  cc.padding = [1, 2]
  cc.width = :max
  cc.frame = :semi
end

ui.space
