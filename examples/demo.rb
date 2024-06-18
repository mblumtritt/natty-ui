# frozen_string_literal: true

require 'natty-ui'

def attributes
  ui.puts <<~TEXT

    Some attributes are widely supported, such as [[bold]]bold[[/]], [[italic]]italic[[/]], [[underline]]underline[[/]], [[blink]]blink[[/]],
    [[invert]]invert[[/]] and [[strike]]strike[[/]], while others are rarely complete or correctly implemented,
    like [[faint]]faint[[/]], [[rapid_blink]]rapid_blink[[/]], [[double_underline]]double_underline[[/]], [[framed]]framed[[/]], [[encircled]]encircled[[/]], [[overlined]]overlined[[/]],
    [[proportional]]proportional[[/]] and [[spacing]]spacing[[/]].

    Different font types are very rarely displayed:

      [[primary_font]]primary_font[[/]]
      [[fraktur]]fraktur[[/]]
      [[font1]]font1[[/]]    [[font2]]font2[[/]]    [[font3]]font3[[/]]
      [[font4]]font4[[/]]    [[font5]]font5[[/]]    [[font6]]font6[[/]]
      [[font7]]font7[[/]]    [[font8]]font8[[/]]    [[font9]]font9[[/]]

  TEXT
end

def colors_3bit
  color = ->(n) { "[[#{n}]]#{n.ljust(14)}[[/]] [[on_#{n}]]sample text[[/]]" }
  %w[black red green yellow blue magenta cyan white].each do |name|
    ui.puts "#{color[name]}    #{color["bright_#{name}"]}"
  end
end

def colors_8bit
  color = ->(i) { "[[bg#{i.to_s(16).rjust(2, '0')}]] #{i.to_s.rjust(2)} " }
  ui.msg 'System Colors', glyph: '[[27]]◉' do
    ui.puts "[[#ff]]#{0.upto(7).map(&color).join}"
    ui.puts "[[#00]]#{8.upto(15).map(&color).join}"
    ui.space
  end

  color = ->(i) { "[[bg#{i.to_s(16)}]] #{i.to_s.rjust(3)} " }
  ui.msg '6x6x6 Color Cube', glyph: '[[27]]◉' do
    [16, 22, 28].each do |b|
      b.step(b + 185, by: 36) do |i|
        left = i.upto(i + 5).map(&color).join
        right = (i + 18).upto(i + 23).map(&color).join
        ui.puts "[[#ff]]#{left}[[bg_default]]  #{right}"
      end
      ui.space
    end
  end

  ui.msg 'Grayscale', glyph: '[[27]]◉' do
    ui.puts "[[#ff]]#{232.upto(243).map(&color).join}"
    ui.puts "[[#ff]]#{244.upto(255).map(&color).join}"
    ui.space
  end
end

def colors_24bit
  ui.puts <<~TEXT
    Modern terminal applications support 24-bit colors for foreground and background
    RGB-color values. Here are just some samples:

  TEXT
  RGB_COLORS.each { ui.puts _1.map { |v| " [[#{v}]]#{v}[[/]] " }.join }
  ui.space
  RGB_COLORS.each { ui.puts _1.map { |v| " [[on:#{v}]]#{v}[[/]] " }.join }
end

def sections
  ui.section do
    ui.puts 'Sections can be stacked'
    ui.section do
      ui.puts TEXT_MID
      ui.framed do
        ui.puts TEXT_MID
        next unless block_given?
        ui.space
        ui.hr
        ui.space
        yield
      end
    end
  end
end

def heading
  ui.h1 'This Is A H1 Heading'
  ui.h2 'This Is A H2 Heading'
  ui.h3 'This Is A H3 Heading'
  ui.h4 'This Is A H4 Heading'
  ui.h5 'This Is A H5 Heading'
end

def messages
  ui.info 'Informative Message', TEXT_MID
  ui.warning 'Warning Message', TEXT_MID
  ui.error 'Error Message', TEXT_MID
  ui.message '[[italic #fad]]Custom Message', TEXT_MID, glyph: '💡'
  ui.failed 'Fail Message', TEXT_MID
end

def list_in_columns
  ui.ls TEXT_LINES
  ui.hr
  ui.ls TEXT_LINES, compact: false
end

def tasks
  ui.task('Initialize') { something }
  ui.task('Establish server connection') do
    ui.task('Open connection') { something }
    ui.task('Send HELO') { something }
    ui.task('Receive OLEH') { something }
    ui.task('Send credentials') { something }
    ui.task('Credentials accepted') { something }
  end
  ui.task 'Loading files' do
    %w[readme.txt main.css main.html sub.html].each do |name|
      ui.msg "Load file [[bright_yellow]]./source/#{name}[[/]]..."
      something
    end
    ui.done 'Files loaded'
  end
  progress = ui.progress('Compress files', max_value: 11)
  11.times do
    progress.step
    something
  end
  progress.done 'All compressed'
end

def table
  ui.table { |tab| TEXT.each_line(chomp: true).each_slice(5) { tab.add(*_1) } }
end

# just simulate some work
def something = sleep(0.5)
def some = sleep(0.15)

TEXT = <<~LOREM
  Lorem [[yellow]]ipsum[[/]] dolor sit
  amet, consectetur adipisicing
  elit, sed do eiusmod tempor
  incididunt ut labore et
  dolore [[red]]magna[[/]] aliqua. Ut
  enim ad minim veniam, quis
  nostrud exercitation ullamco
  laboris nisi ut aliquip ex
  ea commodo [[bold]]consequat[[/]]. Duis
  aute irure [[bold green]]dolor[[/]] in
  reprehenderit in voluptate
  velit [[underline]]esse cillum[[/]] dolore eu
  fugiat nulla pariatur.
  Excepteur sint occaecat
  cupidatat non proident,
  sunt in culpa qui officia
  deserunt mollit anim id
  est laborum.
LOREM
TEXT_LINES = TEXT.lines(chomp: true)
TEXT_MID = TEXT_LINES.take(8).join(' ')
TEXT_BIG = TEXT_LINES.join(' ')
RGB_COLORS = <<~RGB_COLORS.lines(chomp: true).map!(&:split)
  #800000 #8b0000 #a52a2a #b22222 #dc143c #ff0000 #ff6347 #ff7f50
  #cd5c5c #f08080 #e9967a #fa8072 #ffa07a #ff4500 #ff8c00 #ffa500
  #ffd700 #b8860b #daa520 #eee8aa #bdb76b #f0e68c #808000 #ffff00
  #9acd32 #556b2f #6b8e23 #7cfc00 #7fff00 #adff2f #006400 #008000
  #228b22 #00ff00 #32cd32 #90ee90 #98fb98 #8fbc8f #00fa9a #00ff7f
  #2e8b57 #66cdaa #3cb371 #20b2aa #2f4f4f #008080 #008b8b #00ffff
  #00ffff #e0ffff #00ced1 #40e0d0 #48d1cc #afeeee #7fffd4 #b0e0e6
  #5f9ea0 #4682b4 #6495ed #00bfff #1e90ff #add8e6 #87ceeb #87cefa
RGB_COLORS

ui.page do
  ui.h1 'NattyUI Demo'
  loop do
    ui.space
    choice, title =
      ui.query(
        'Which Demo part do you like to see?',
        :a => 'Attributes',
        '3' => '3-bit and 4-bit Colors',
        '8' => '8-bit Colors',
        '2' => '24-bit colors',
        'l' => 'List in Columns',
        's' => 'Sections',
        'S' => 'Sections with lists',
        'z' => 'Sections with table',
        't' => 'Tasks',
        :q => 'Quit Demo',
        :result => :all,
        :display => :compact
      )
    break if choice.nil? || choice == 'q'
    ui.cls.h2(title).space
    case choice
    when 'a'
      attributes
    when '3'
      colors_3bit
    when '8'
      colors_8bit
    when '2'
      colors_24bit
    when 't'
      tasks
    when 'l'
      list_in_columns
    when 's'
      sections { messages }
    when 'S'
      sections { list_in_columns }
    when 'z'
      sections { table }
    end
  end
end
