# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Print Horizontal Bars[/]' do
  values = [11.97, 14.35, 15.51, 12.39, 14.3, 10.6, 17.7].freeze

  ui.space
  ui.hbars values, style: :blue
  ui.puts 'NattyUI can quick dump values as horizontal bars.'

  ui.space
  ui.hbars values, style: :green, normalize: true, width: 0.5
  ui.puts(
    'These are the same values but [i]normalized[/i] ' \
      'and printed in half width.'
  )
end
