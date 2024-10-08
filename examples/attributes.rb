# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h2 'NattyUI: ANSI Attributes', space: 2

ui.puts <<~PARA1.tr("\n", ' ')
  Some attributes are widely supported, such as [b]bold[/b],
  [i]italic[/i], [u]underline[/u], [bl]blink[/bl], [inv]invert[/inv] and
  [s]strike[/s], while others are rarely complete or correctly implemented, like
  [faint]faint[/faint], [double_underline]double underline[/],
  [curly_underline]curly underline[/], [dotted_underline]dotted underline[/],
  [dashed_underline]dashed underline[/], [rapid_blink]rapid_blink[/],
  [framed]framed[/], [encircled]encircled[/], [overlined]overlined[/] and
  [proportional]proportional[/].
PARA1

ui.puts <<~PARA2.tr("\n", ' ')
  Alternative fonts are mostly completely ignored:
  [primary_font]primary_font[/], [fraktur]fraktur[/],
  [font1]font1[/], [font2]font2[/], [font3]font3[/],
  [font4]font4[/], [font5]font5[/], [font6]font6[/],
  [font7]font7[/], [font8]font8[/], [font9]font9[/].
PARA2

ui.space
