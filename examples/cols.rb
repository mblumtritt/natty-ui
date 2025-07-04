# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Print Columns[/]' do
  ui.space
  ui.cols(
    'Here we',
    'have some',
    'columns',
    'which are',
    'arranged',
    'and centered',
    align: :centered,
    border: :default
  )

  ui.space
  ui.cols do |cc|
    cc.add(
      "This is a left aligned blue column with some text but also with with\n" \
        'a forced line break.',
      style: 'bright_white on_blue',
      align: :left
    )
    cc.add(
      'This is the middle red column.',
      style: 'bright_white on_red',
      align: :centered,
      vertical: :middle
    )
    cc.add(
      'This is a right aligned blue column vertically bottom aligned.',
      style: 'bright_white on_blue',
      align: :right,
      vertical: :bottom
    )
    cc.padding = [1, 2]
  end
end
