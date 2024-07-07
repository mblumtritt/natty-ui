# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.puts '⌨️ Display Keyboard Input [[bright_black]](Exit with Ctrl+C)'

ui.section prefix: '[[blue]]:[[/]] ' do
  while true
    raw, name = NattyUI.read_key(mode: :both)
    ui.puts "[[yellow]]#{raw.inspect}[[/]] [[bold bright_green]]#{name}[[/]]"
    break if name == 'Ctrl+C'
  end
end
