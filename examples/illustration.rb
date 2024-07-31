# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space

ui.table(type: :undecorated) do |table|
  table.add(
    'Styles',
    "Support of all ANSI styles like #{
      %w[
        bold
        italic
        underline
        invert
        strike
        faint
        double_underline
        curly_underline
        dotted_underline
        dashed_underline
        blink
      ].map { "[#{_1}]#{_1.tr('_', ' ')}[/]" }.join(', ')
    }, and even rarely supported like [fraktur]fraktur[/fraktur]."
  )

  table.add('Colors', <<~TEXT)
    ✓ [green]3/4-bit color[/]         ✓ [ff7f50]Truecolor (16.7 million)
    ✓ [1b]8-bit color[/]           ✓ [bright_yellow]Dumb terminals
    ✓ [bright_blue]NO_COLOR convention
  TEXT

  table.add(
    'Markup',
    '[0c]You can style your text using a [i]BBCode[/i]-like syntax.'
  )

  table.add('Layout', <<~TEXT)
    🎩 heading elements     📏 horizontal rulers
    📝 messages             [yellow]🄵[/]  framed blocks
    [blue]┼┼[/] tables
  TEXT

  table.add('Tools', <<~TEXT)
    ✅ tasks                [bold green]…[/]  progress bars
    [bold bright_white]>[bright_red]_[/] user input           🔦 text animation
  TEXT

  table.add("Asian\nlanguage\nsupport", <<~TEXT)
    [0a]🇨🇳 该库支持中文，日文和韩文文本！
    [0a]🇯🇵 ライブラリは中国語、日本語、韓国語のテキストをサポートしています
    [0a]🇰🇷 이 라이브러리는 중국어, 일본어 및 한국어 텍스트를 지원합니다
  TEXT

  table.align_column(0, :center)
  table.style_column(0, :red)
end

ui.space
