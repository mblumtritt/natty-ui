# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Sections[/]' do
  ui.space
  ui.information 'Informative Message' do
    ui.puts <<~TEXT, ignore_newline: true
      Sections and messages are elements which support any other feature. This
      means they may contain text, other sections, titles, horizontal rules,
      lists, progress bars and much more!
    TEXT
  end

  ui.space
  ui.warning "Warning\nThis is a warning message example."

  ui.space
  ui.error 'Error Message' do
    ui.space
    ui.cols do |cc|
      cc.add "()-()\n \\\"/\n  `", width: 6, style: :yellow
      cc.add 'You can add all other elements to a section.', vertical: :middle
    end
  end
end
