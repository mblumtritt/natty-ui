# frozen_string_literal: true

require_relative '../lib/natty-ui'

raw = name = :start
while name != 'Esc'
  ui.temporary do
    ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Keyboard Key Codes[/]' do
      ui.puts(
        "\n#{
          case name
          when :start
            "Your terminal uses [i]#{
              Terminal.input_mode
            }[/i] mode. Press a key!"
          when nil
            "[green]#{raw.inspect}[/fg] → [bold bright_green][\\#{raw}]"
          else
            "[green]#{raw.inspect}[/fg] → [bold bright_green]#{
              name.split('+').map! { "[\\#{_1}]" }.join(' ')
            }"
          end
        }\n\n[bright_black](Exit with ESC)"
      )
    end
    raw, name = Terminal.read_key(mode: :both)
  end
end
