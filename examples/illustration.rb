# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.msg('Natty UI', glyph: '⭐️') do
  ui.table(type: :cols, expand: :equal) do |table|
    table.add_row(
      'This is the [[c4]]beautiful[[/]], [[c5]]nice[[/]], [[c6]]nifty[[/]], ' \
        '[[c7]]fancy[[/]], [[c8]]neat[[/]], [[c9]]pretty[[/]],  ' \
        '[[ca]]cool[[/]], [[cb]]lovely[[/]], [[cc]]natty[[/]] ' \
        '[[bold]]user interface[[/]] you like to have for your command line ' \
        'applications.',
      'It contains [[italic curly_underline ulc4]]elegant[[/]], ' \
        '[[italic underline ulc7]]simple[[/]] and ' \
        '[[italic dotted_underline ulca]]beautiful[[/]] tools that enhance ' \
        'your command line interfaces functionally and aesthetically.'
    )
    table.align_column(1, :right)
  end
end

ui.msg('Features', glyph: '⭐️') { ui.ls(<<~FEATURES.lines(chomp: true)) }
    [[bold red]]T[[/]]  text attributes
    🌈 text coloring
    🔦 text animation
    🎩 heading elements
    📏 horizontal rulers
    📝 messages
    [[bold blue]]""[[/]] quote blocks
    [[yellow]]🄵[[/]]  framed blocks
    ✅ tasks
    [[bold green]]…[[/]]  progress bars
    [[blue]]┼┼[[/]] tables
    [[bold bright_white]]>[[bright_red]]_[[/]] user input
  FEATURES
