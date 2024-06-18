# frozen_string_literal: true

require 'natty-ui'

ui.space
ui.h1 '3/4-bit Color Support'
ui.space

color = ->(n) { "[[#{n}]]#{n.ljust(14)}[[/]] [[on_#{n}]] sample text [[/]]" }
%w[black red green yellow blue magenta cyan white].each do |name|
  ui.puts "#{color[name]}    #{color["bright_#{name}"]}"
end
ui.space
