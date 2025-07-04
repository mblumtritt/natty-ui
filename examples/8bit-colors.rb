# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]8bit Color Support[/]' do
  color = ->(i) { "[bg#{i = i.to_s(16).rjust(2, '0')}] #{i} " }

  ui.space
  ui.message('System Colors', <<~COLORS.chomp)
    [#ff]#{0.upto(7).map(&color).join}
    [#00]#{8.upto(15).map(&color).join}
  COLORS

  ui.space
  ui.message('Grayscale', <<~GRAYSCALE.chomp)
    [#ff]#{0xe8.upto(0xf3).map(&color).join}
    [#ff]#{0xf4.upto(0xff).map(&color).join}
  GRAYSCALE

  ui.space
  ui.message '6x6x6 Color Cube' do
    [16, 22, 28].each do |b|
      b.step(b + 185, by: 36) do |i|
        left = i.upto(i + 5).map(&color).join
        right = (i + 18).upto(i + 23).map(&color).join
        ui.puts "[#ff]#{left}[bg_default]#{right}"
      end
    end
  end
end
