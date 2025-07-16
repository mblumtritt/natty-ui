# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]24-bit Color Support[/]' do
  bar = '█' * ui.columns
  rainbow =
    (7..17).map do |i|
      NattyUI::Ansi.rainbow(bar, seed: 3, spread: 3.25, frequency: i / 100.0)
    end

  ui.space
  ui.puts(*rainbow)
end
