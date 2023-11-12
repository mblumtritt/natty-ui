# frozen_string_literal: true

# require 'natty-ui'
require_relative '../lib/natty-ui'

UI = NattyUI::StdOut

# helper:
def hex(int) = int.to_s(16).rjust(2, '0')

UI.space
UI.h1 'NattyUI ANSI Attributes Demo', <<~TEXT

  This text contains all supported ANSI attrubtes and explains the available
  colors.

  Please, keep in mind that no all terminals will support of all attributes and
  color types used in this text. In fact, you can use the output of this text to
  check the supported ANSI attributes.

TEXT

UI.h2 'Attributes', <<~TEXT

  Some attributes are widely supported, such as [[bold]]bold[[/]], [[italic]]italic[[/]], [[underline]]underline[[/]], [[blink]]blink[[/]],
  [[invert]]invert[[/]] and [[strike]]strike[[/]], while others are rarely complete or correctly implemented,
  like [[faint]]faint[[/]], [[rapid_blink]]rapid_blink[[/]], [[double_underline]]double_underline[[/]], [[framed]]framed[[/]], [[encircled]]encircled[[/]], [[overlined]]overlined[[/]],
  [[proportional]]proportional[[/]] and [[spacing]]spacing[[/]].

  Different font types are very rarely displayed:

    - [[primary_font]]primary_font[[/]]
    - [[font1]]font1[[/]]
    - [[font2]]font2[[/]]
    - [[font3]]font3[[/]]
    - [[font4]]font4[[/]]
    - [[font5]]font5[[/]]
    - [[font6]]font6[[/]]
    - [[font7]]font7[[/]]
    - [[font8]]font8[[/]]
    - [[font9]]font9[[/]]
    - [[fraktur]]fraktur[[/]]

TEXT

UI.h2 '3-bit and 4-bit Colors' do |sec|
  sec.space
  colors = %w[black red green yellow blue magenta cyan white].freeze
  (colors + colors.map { |name| "bright_#{name}" }).each do |name|
    sec.puts "  [[#{name}]]#{name.ljust(14)}[[/]] [[on_#{name}]]sample text"
  end
end
UI.space

UI.h2 '8-bit Colors' do |sec|
  sec.space
  sec.puts 'There are 256 pre-defined color which can be used by their index:'
  sec.space

  colors_std = 0.upto(15).map { |i| hex(i) }
  colors216 = 16.upto(231).lazy.map { |i| hex(i) }
  colors_gray1 = 232.upto(243).map { |i| hex(i) }
  colors_gray2 = 244.upto(255).map { |i| hex(i) }

  sec.puts colors_std.map { |i| "[[#{i}]] #{i} [[/]]" }.join
  colors216.each_slice(18) do |slice|
    sec.puts slice.map { |i| "[[#{i}]] #{i} [[/]]" }.join
  end
  sec.puts colors_gray1.map { |i| "[[#{i}]] #{i} [[/]]" }.join
  sec.puts colors_gray2.map { |i| "[[#{i}]] #{i} [[/]]" }.join

  sec.space
  sec.puts colors_std.map { |i| "[[on:#{i}]] #{i} [[/]]" }.join
  colors216.each_slice(18) do |slice|
    sec.puts slice.map { |i| "[[on:#{i}]] #{i} [[/]]" }.join
  end
  sec.puts colors_gray1.map { |i| "[[on:#{i}]] #{i} [[/]]" }.join
  sec.puts colors_gray2.map { |i| "[[on:#{i}]] #{i} [[/]]" }.join
end

UI.space
UI.h2 '24-bit colors' do |sec|
  sec.puts <<~TEXT

    Modern terminal applications support 24-bit colors for foreground and background
    RGB-color values. Here are just some samples:

  TEXT

  some_rgb = DATA.readlines(chomp: true).lazy.each_slice(8)

  some_rgb.each do |slice|
    sec.puts slice.map { |v| " [[#{v}]]#{v}[[/]] " }.join
  end
  sec.space
  some_rgb.each do |slice|
    sec.puts slice.map { |v| " [[on:#{v}]]#{v}[[/]] " }.join
  end
end
UI.space

__END__
#800000
#8b0000
#a52a2a
#b22222
#dc143c
#ff0000
#ff6347
#ff7f50
#cd5c5c
#f08080
#e9967a
#fa8072
#ffa07a
#ff4500
#ff8c00
#ffa500
#ffd700
#b8860b
#daa520
#eee8aa
#bdb76b
#f0e68c
#808000
#ffff00
#9acd32
#556b2f
#6b8e23
#7cfc00
#7fff00
#adff2f
#006400
#008000
#228b22
#00ff00
#32cd32
#90ee90
#98fb98
#8fbc8f
#00fa9a
#00ff7f
#2e8b57
#66cdaa
#3cb371
#20b2aa
#2f4f4f
#008080
#008b8b
#00ffff
#00ffff
#e0ffff
#00ced1
#40e0d0
#48d1cc
#afeeee
#7fffd4
#b0e0e6
#5f9ea0
#4682b4
#6495ed
#00bfff
#1e90ff
#add8e6
#87ceeb
#87cefa