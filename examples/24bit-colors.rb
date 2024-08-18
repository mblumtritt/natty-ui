# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: 24-bit Color Support', space: 2

ui.section do
  bar = '█' * ui.available_width
  rainbow =
    (7..17).map do |i|
      NattyUI::Ansi.rainbow(bar, seed: 3, spread: 3.25, frequence: i / 100.0)
    end

  ui.puts(*rainbow)
end

ui.space
