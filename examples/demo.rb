# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.page do
  ui.h1 'NattyUI: Examples', space: 2

  ruby =
    ENV.fetch('RUBY') do
      require('rbconfig')
      File.join(
        RbConfig::CONFIG['bindir'],
        "#{RbConfig::CONFIG['ruby_install_name']}#{RbConfig::CONFIG['EXEEXT']}"
      ).sub(/.*\s.*/m, '"\&"')
    end
  run = ->(name) { system(ruby, File.join(__dir__, "#{name}.rb")) }
  run['illustration']

  ui.space

  choices = {}
  examples = {}
  {
    '1' => ['attributes', 'ANSI Attributes'],
    '2' => ['3bit-colors', '3/4-bit Color Support'],
    '3' => ['8bit-colors', '8-bit Color Support'],
    '4' => ['24bit-colors', '24-bit Color Support'],
    '5' => ['message', 'Message Types'],
    '6' => ['ls', 'Print In Columns'],
    '7' => %w[table Tables],
    '8' => ['animate', 'Text Line Animation'],
    '9' => ['progress', 'Progress Indication'],
    '0' => ['query', 'User Queries'],
    'ESC' => [nil, 'Exit Demo']
  }.each_pair do |key, (name, descr)|
    examples[key] = name
    choices[key] = descr
  end

  loop do
    choice =
      ui.query(
        'Which example do you like to run?',
        display: :compact,
        **choices
      ) or break
    example = examples[choice] or break
    ui.cls
    run[example]
  end
end
