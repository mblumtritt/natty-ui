# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: 8-bit Color Support'
ui.space

color = ->(i) { "[[bg#{i = i.to_s(16).rjust(2, '0')}]] #{i} " }
ui.msg 'System Colors', glyph: '[[27]]◉' do
  ui.puts "[[#ff]]#{0.upto(7).map(&color).join}"
  ui.puts "[[#00]]#{8.upto(15).map(&color).join}"
  ui.space
end

ui.msg '6x6x6 Color Cube', glyph: '[[27]]◉' do
  [16, 22, 28].each do |b|
    b.step(b + 185, by: 36) do |i|
      left = i.upto(i + 5).map(&color).join
      right = (i + 18).upto(i + 23).map(&color).join
      ui.puts "[[#ff]]#{left}[[bg_default]]  #{right}"
    end
    ui.space
  end
end

ui.msg 'Grayscale', glyph: '[[27]]◉' do
  ui.puts "[[#ff]]#{232.upto(243).map(&color).join}"
  ui.puts "[[#ff]]#{244.upto(255).map(&color).join}"
  ui.space
end
