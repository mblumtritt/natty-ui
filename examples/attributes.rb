# frozen_string_literal: true

require 'natty-ui'

ui.space
ui.h1 'NattyUI ANSI Attributes Demo'
ui.puts <<~TEXT

  This text contains all supported ANSI attrubtes and explains the available
  colors.

  Please, keep in mind that no all terminals will support of all attributes and
  color types used in this text. In fact, you can use the output of this text to
  check the supported ANSI attributes.

TEXT

ui.h2 'Attributes'
ui.puts <<~TEXT

  Some attributes are widely supported, such as [[bold]]bold[[/]], [[italic]]italic[[/]], [[underline]]underline[[/]], [[blink]]blink[[/]],
  [[invert]]invert[[/]] and [[strike]]strike[[/]], while others are rarely complete or correctly implemented,
  like [[faint]]faint[[/]], [[rapid_blink]]rapid_blink[[/]], [[double_underline]]double_underline[[/]], [[framed]]framed[[/]], [[encircled]]encircled[[/]], [[overlined]]overlined[[/]],
  [[proportional]]proportional[[/]] and [[spacing]]spacing[[/]].

  Different font types are very rarely displayed:

    [[primary_font]]primary_font[[/]]
    [[fraktur]]fraktur[[/]]
    [[font1]]font1[[/]]    [[font2]]font2[[/]]    [[font3]]font3[[/]]
    [[font4]]font4[[/]]    [[font5]]font5[[/]]    [[font6]]font6[[/]]
    [[font7]]font7[[/]]    [[font8]]font8[[/]]    [[font9]]font9[[/]]

TEXT

ui.h2 '3-bit and 4-bit Colors'
ui.space
color = ->(n) { "[[#{n}]]#{n.ljust(14)}[[/]] [[on_#{n}]]sample text[[/]]" }
%w[black red green yellow blue magenta cyan white].each do |name|
  ui.puts "#{color[name]}    #{color["bright_#{name}"]}"
end
ui.space

ui.h2 '8-bit Colors'
ui.space
ui.puts 'There are 256 pre-defined color which can be used by their index:'
ui.space

color = ->(i) { "[[bg#{i.to_s(16).rjust(2, '0')}]] #{i.to_s.rjust(2)} " }
ui.msg 'System Colors', glyph: '[[27]]◉' do
  ui.puts "[[#ff]]#{0.upto(7).map(&color).join}"
  ui.puts "[[#00]]#{8.upto(15).map(&color).join}"
  ui.space
end

color = ->(i) { "[[bg#{i.to_s(16)}]] #{i.to_s.rjust(3)} " }
ui.msg '6x6x6 Color Cube', glyph: '[[27]]◉' do
  [16, 22, 28].each do |b|
    b.step(b + 185, by: 36) do |i|
      left = i.upto(i + 5).map(&color).join
      right = (i + 18).upto(i + 23).map(&color).join
      ui.puts "[[#ff]]#{left}[[bg_default]]  #{right}"
    end
    ui.space
  end

  ui.msg 'Grayscale', glyph: '[[27]]◉' do
    ui.puts "[[#ff]]#{232.upto(243).map(&color).join}"
    ui.puts "[[#ff]]#{244.upto(255).map(&color).join}"
    ui.space
  end
end
