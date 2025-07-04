# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Print Tables[/]' do
  ui.space
  ui.table(border: :rounded, border_around: true) do |table|
    table.add(
      'Header Col 0',
      'Header Col 1',
      'Header Col 2',
      align: :centered,
      style: %i[bold red]
    )

    table.add do |row|
      row.add '[blue]Row 1 Col 0', align: :left, vertical: :middle
      row.add '[blue]Row 1 Col 1', "Line 2\nLine 3", align: :right
      row.add '[blue]Row 1 Col 2', align: :centered, vertical: :bottom
      row.padding = [0, 2]
    end

    filler_text = <<~FILLER.tr("\n", ' ')
      This is some filler text to demonstrate word-wise line breaks inside
      a table cell. Please, just ignore this nonsense-text gently.
    FILLER
    table.add do |row|
      row.add '[blue]Row 2 Col 0', filler_text, align: :right
      row.add '[blue]Row 2 Col 1', filler_text, align: :centered
      row.add '[blue]Row 2 Col 2', filler_text, align: :left
      row.padding = [1, 2]
    end
  end

  ui.space
  ui.table(border_style: :bright_blue, border: :default) do |table|
    table.add(*('A'..'Z').each_slice(2).map(&:join))
    table.add(*('😀'..'😌'))
    table.add(*(3..15).map { _1.to_s(3) })
    table.each do |row|
      row.align = :centered
      row.style = :bright_yellow
    end
  end

  ui.space
  ui.table do |table|
    table.add do |row|
      row.add 'green', style: :on_green
      row.add 'blue', style: :on_blue
      row.add 'red', style: :on_red
      row.width = 15
      row.align = :centered
    end
    table.add do |row|
      row.add 'yellow', style: :on_yellow
      row.add 'magenta', style: :on_magenta
      row.add 'cyan', style: :on_cyan
      row.align = :centered
    end
  end
end
