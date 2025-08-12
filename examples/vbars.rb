# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Print Vertical Bars[/]' do
  values = [
    11.97,
    14.35,
    15.51,
    12.39,
    14.3,
    10.6,
    17.7,
    14.47,
    14.56,
    17.31,
    12.98,
    16.21,
    14.9,
    17.23,
    13.35,
    11.62,
    14.81,
    19.7,
    13.42,
    14.18
  ].freeze

  ui.space
  ui.vbars values, style: :blue
  ui.puts 'NattyUI can quick dump values as vertical bars.'

  ui.space
  ui.vbars values, style: :green, normalize: true, bar_width: 2
  ui.puts(
    'These are the same values but [i]normalized[/i] and printed with ' \
      'a fixed bar width.'
  )
end
