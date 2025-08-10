# frozen_string_literal: true

require_relative '../lib/natty-ui'

def colors
  return Terminal.colors.to_s if Terminal.colors < 8
  colors = [
    Terminal.true_color? ? 'true color' : Terminal.colors,
    "#{(0..15).map { "[#{_1.to_s(16).rjust(2, '0')}]██" }.join}[/]"
  ]
  if Terminal.true_color?
    colors << Terminal::Ansi.rainbow('████████████████████████████████')
  end
  colors.join("\n")
end

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Terminal Information[/]' do
  ui.space
  ui.table do |table|
    table.add('Identifier', Terminal.application || 'unidentified')
    table.add('ANSI support', Terminal.ansi? ? 'yes' : 'no')
    table.add('Input mode', Terminal.input_mode)
    table.add('Colors', colors)
    table.add('Screen size', Terminal.size.join(' x '))
    fc = table.columns[0]
    fc.width = 14
    fc.padding_right = 2
    fc.align = :right
    table.columns[1].style = :bold
  end
end
