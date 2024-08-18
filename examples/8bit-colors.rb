# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: 8-bit Color Support', space: 2

color = ->(i) { "[bg#{i = i.to_s(16).rjust(2, '0')}] #{i} " }
ui.msg 'System Colors' do
  ui.puts <<~COLORS
    [#ff]#{0.upto(7).map(&color).join}
    [#00]#{8.upto(15).map(&color).join}

  COLORS
end

ui.msg '6x6x6 Color Cube' do
  [16, 22, 28].each do |b|
    b.step(b + 185, by: 36) do |i|
      left = i.upto(i + 5).map(&color).join
      right = (i + 18).upto(i + 23).map(&color).join
      ui.puts "[#ff]#{left}[bg_default]  #{right}"
    end
    ui.space
  end
end

ui.msg 'Grayscale' do
  ui.puts <<~GRAYSCALE
    [#ff]#{232.upto(243).map(&color).join}
    [#ff]#{244.upto(255).map(&color).join}

  GRAYSCALE
end
