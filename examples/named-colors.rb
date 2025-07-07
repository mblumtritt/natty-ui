# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Named Colors Support[/]' do
  ui.puts <<~INFO

    NattyUI supports a series of named color values, such as those  supported by Kitty.

  INFO

  ui.information('Note') do
    ui.puts('Not all terminal emulators support true-colors.')
  end

  ui.space
  ui.ls(
    NattyUI::Ansi
      .named_colors
      .delete_if { /\d/.match?(_1) }
      .map! { "[bg_#{_1}] [/bg] [#{_1}]#{_1}[/fg]" }
  )
end
