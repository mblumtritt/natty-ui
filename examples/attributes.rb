# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]ANSI Attributes[/]' do
  ui.space
  ui.puts <<~INFO_1, <<~INFO_2, ignore_newline: true
    NattyUI supports all well known attributes like
    [b]bold[/b],
    [i]italic[/i],
    [u]underline[/u],
    [blink]blink[/blink],
    [inv]invert[/inv]
    and [strike]strike[/strike].
    Other attributes like
    [faint]faint[/faint],
    [double_underline]double underline[/],
    [curly_underline]curly underline[/],
    [dotted_underline]dotted underline[/],
    [dashed_underline]dashed underline[/],
    [rapid_blink]rapid_blink[/],
    [framed]framed[/],
    [encircled]encircled[/],
    [overlined]overlined[/]
    and [proportional]proportional[/]
    are not widely used but also supported.
  INFO_1
    Alternative fonts are mostly completely ignored:
    [primary_font]primary_font[/], [fraktur]fraktur[/],
    [font1]font1[/], [font2]font2[/], [font3]font3[/],
    [font4]font4[/], [font5]font5[/], [font6]font6[/],
    [font7]font7[/], [font8]font8[/], [font9]font9[/].
  INFO_2
end
