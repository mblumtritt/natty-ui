# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: 3/4-bit Color Support', space: 2

color = ->(n, j) { "[#{n}]#{n.ljust(j)}[/] [on_#{n}] sample text [/]" }
%w[black red green yellow blue magenta cyan white].each do |name|
  ui.puts "#{color[name, 7]}    #{color["bright_#{name}", 14]}"
end

ui.space
