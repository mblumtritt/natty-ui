# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b]' do
  ui.table(border: :defaulth, border_style: 'bright_blue') do |table|
    table.add do |row|
      row.add 'Styles'
      row.add <<~TEXT.tr("\n", ' ')
        Support of all ANSI styles like
        [bold]bold[/bold],
        [italic]italic[/italic],
        [underline]underline[/underline],
        [invert]invert[/invert],
        [strike]strike[/strike],
        [faint]faint[/faint],
        [double_underline]double underline[/double_underline],
        [curly_underline]curly underline[/curly_underline],
        [dotted_underline]dotted underline[/dotted_underline],
        [dashed_underline]dashed underline[/dashed_underline]
        and even rarely supported like [fraktur]fraktur[/fraktur].
      TEXT
    end

    table.add do |row|
      row.add 'Colors'
      row.add <<~TEXT.chomp
        ✓ [palegreen]3/4-bit color[/fg]         ✓ [ff7f50]Truecolor (16.7 million)
        ✓ [skyblue]8-bit color[/fg]           ✓ [gold]Dumb terminals
        ✓ [tan1]NO_COLOR convention
      TEXT
    end

    table.add do |row|
      row.add 'Markup'
      row.add '[0c]You can style your text using a [i]BBCode[/i]-like syntax.'
    end

    table.add do |row|
      row.add 'Layout'
      row.add <<~TEXT.chomp
        🎩 heading elements     📝 messages    📊 bar graphs
        📏 horizontal rulers    [blue]┼┼[/] tables
        📋 lists                [b green]✓✓[/] tasks
      TEXT
    end

    table.add do |row|
      row.add 'Asian', 'language', 'support'
      row.add <<~TEXT.chomp
        [bright_green]🇨🇳 该库支持中文，日文和韩文文本！
        [bright_green]🇯🇵 ライブラリは中国語、日本語、韓国語のテキストをサポートしています
        [bright_green]🇰🇷 이 라이브러리는 중국어, 일본어 및 한국어 텍스트를 지원합니다
      TEXT
    end

    table.columns[0].style = 'bold red'
    table.columns[0].width = 10
    table.columns[1].padding_right = 2
  end
end
