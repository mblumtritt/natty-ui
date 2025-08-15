# frozen_string_literal: true

require_relative '../lib/natty-ui'

event = nil
while true
  ui.temporary do
    ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Keyboard Key Codes[/]' do
      ui.puts(
        "
        #{
          if event
            "#{event.to_a.size < 2 ? ' Key' : 'Keys'}: [bold bright_green]#{
              event.to_a.map { "[\\#{_1}]" }.join(' ')
            }[/]
            Code: [bright_blue]#{event.raw.inspect}[/]"
          else
            "Your terminal uses [bright_blue]#{
              Terminal.input_mode
            }[/] mode. Press a key!"
          end
        }

        [faint](Exit with ESC)"
      )
    end
    event = Terminal.read_key_event
    exit if event.nil? || event.name == 'Esc'
  end
end
