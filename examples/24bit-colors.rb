# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: 24-bit Color Support'
ui.space

RGB_COLORS = <<~SAMPLES.lines(chomp: true).map!(&:split)
  #800000 #8b0000 #a52a2a #b22222 #dc143c #ff0000 #ff6347 #ff7f50
  #cd5c5c #f08080 #e9967a #fa8072 #ffa07a #ff4500 #ff8c00 #ffa500
  #ffd700 #b8860b #daa520 #eee8aa #bdb76b #f0e68c #808000 #ffff00
  #9acd32 #556b2f #6b8e23 #7cfc00 #7fff00 #adff2f #006400 #008000
  #228b22 #00ff00 #32cd32 #90ee90 #98fb98 #8fbc8f #00fa9a #00ff7f
  #2e8b57 #66cdaa #3cb371 #20b2aa #2f4f4f #008080 #008b8b #00ffff
  #00ffff #e0ffff #00ced1 #40e0d0 #48d1cc #afeeee #7fffd4 #b0e0e6
  #5f9ea0 #4682b4 #6495ed #00bfff #1e90ff #add8e6 #87ceeb #87cefa
SAMPLES

RGB_COLORS.each { ui.puts _1.map { |v| " [[#{v}]]#{v}[[/]] " }.join }
ui.space
RGB_COLORS.each { ui.puts _1.map { |v| " [[on:#{v}]]#{v}[[/]] " }.join }
ui.space
RGB_COLORS.each do |code|
  ui.puts code.map { |v| " [[underline ul:#{v}]]#{v}[[/]] " }.join
end
ui.space
