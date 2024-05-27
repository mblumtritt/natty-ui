# frozen_string_literal: true

require 'natty-ui'

ui.space
ui.msg('Natty UI', glyph: '⭐️') { ui.puts <<~TEXT }
  This is the [[c4]]beautiful[[/]], [[c5]]nice[[/]], [[c6]]nifty[[/]], [[c7]]fancy[[/]], [[c8]]neat[[/]], [[c9]]pretty[[/]],  [[ca]]cool[[/]],
  [[cb]]lovely[[/]], [[cc]]natty[[/]] [[bold]]user interface[[/]] you like to have for your command
  line applications. It contains [[italic]]elegant[[/]], [[italic]]simple[[/]] and [[italic]]beautiful[[/]]
  tools that enhance your command line interfaces functionally and
  aesthetically.
TEXT
ui.msg('Features', glyph: '⭐️') { ui.ls(<<~FEATURES.lines(chomp: true)) }
  [[bold red]]T[[/]] text attributes
  🌈 text coloring
  🎩 heading elements
  📏 horizontal rulers
  📝 message blocks
  ✅ task blocks
  [[bold blue]]""[[/]] quote blocks
  🖼️ framed blocks
  [[yellow]]┼┼[[/]] tables
  💯 progress bars
  [[bold red]]?[[/]] ask question
  [[bold bright_white]]>[[bright_red]]_[[/]] user input
FEATURES
