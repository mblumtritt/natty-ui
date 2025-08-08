# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]3/4bit Color Support[/]' do
  ui.space
  ui.puts <<~INFO, eol: false
    Terminals may support colors. You can colorize foreground text and
    background. The very basic color palette consists of eight colors and may
    be extended with eight colors which are much brighter.
  INFO

  ui.space
  ui.ls(
    %w[
      black
      red
      green
      yellow
      blue
      magenta
      cyan
      white
      bright_black
      bright_red
      bright_green
      bright_yellow
      bright_blue
      bright_magenta
      bright_cyan
      bright_white
    ].map { |name| "[bg_#{name}]  [/bg] [#{name}]#{name}[/fg]" }
  )
end
