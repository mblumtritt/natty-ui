# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: 24-bit Color Support'
ui.space

RGB_COLORS = <<~SAMPLES.lines(chomp: true).map!(&:split)
  #219c90 #ef9c66 #240750 #26355d #808836 #f5eee6
  #fff455 #fcdc94 #344c64 #af47d2 #ffbf00 #fff8e3
  #ffc700 #c8cfa0 #577b8d #ff8f00 #ff9a00 #f3d7ca
  #ee4e4e #78aba8 #57a6a1 #ffdb00 #d10363 #e6a4b4
SAMPLES

RGB_COLORS.each { |code| ui.puts code.map { |v| " [[#{v}]]#{v}[[/]] " }.join }
ui.space
RGB_COLORS.each do |code|
  ui.puts code.map { |v| " [[on:#{v}]]#{v}[[/]] " }.join
end
ui.space
RGB_COLORS.each do |code|
  ui.puts code.map { |v| " [[underline ul:#{v}]]#{v}[[/]] " }.join
end
ui.space
