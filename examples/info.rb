# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Terminal Information[/]' do
  ui.space
  ui.table do |table|
    table.add('Identifier', Terminal.application || 'unidentified')
    table.add('ANSI support', Terminal.ansi? ? 'yes' : 'no')
    table.add('Input mode', Terminal.input_mode)
    table.add(
      'Colors',
      "#{Terminal.true_color? ? 'true color' : Terminal.colors}
      [black]██[red]██[green]██[yellow]██[blue]██[magenta]██[cyan]██[white]██" \
        '[bright_black]██[bright_red]██[bright_green]██[bright_yellow]██' \
        '[bright_blue]██[bright_magenta]██[bright_cyan]██[bright_white]██[/]' \
        "#{
          if Terminal.true_color?
            Terminal::Ansi.rainbow("\n████████████████████████████████")
          end
        }"
    )
    table.add('Screen size', Terminal.size.join(' x '))
    fc = table.columns[0]
    fc.width = 13
    fc.padding_right = 1
    fc.align = :right
    table.columns[1].style = :bold
  end
end
