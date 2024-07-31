# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: 3/4-bit Color Support'
ui.space

color = ->(n, j) { "[#{n}]#{n.ljust(j)}[/] [on_#{n}] sample text [/]" }
%w[black red green yellow blue magenta cyan white].each do |name|
  ui.puts "#{color[name, 7]}    #{color["bright_#{name}", 14]}"
end

ui.space
