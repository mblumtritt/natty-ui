# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Options and Selections[/]' do
  ui.space
  ui.puts <<~INFO, eol: false
    [i]Options[/i] and [i]selections[/i] allow the user to select from several
    options interactively.
    If ANSI is available the user can use [b][Up][/b] and [b][Down][/b] keys to
    navigate, switch the state of selected item with [b][Space][/b] and complete
    the selection with [b][Enter][/b].
  INFO

  ui.space
  options =
    ui.select %w[Kitty iTerm2 Ghostty Tabby Rio] do
      ui.puts '[i]Which terminal applications did you already tested?[/i]'
    end
  case options.size
  when 0
    ui.puts 'You selected nothing – test more in future!'
  when 1
    ui.puts "#{options.first} is indeed a nice terminal."
  else
    ui.puts "#{options.join(', ')} are worth to test!"
  end
end
