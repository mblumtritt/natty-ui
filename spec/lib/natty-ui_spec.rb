# frozen_string_literal: true

RSpec.describe NattyUI do
  context 'when ANSI is supported' do
    include_context 'with Terminal.rb', size: [25, 14]

    it 'prints a string' do
      NattyUI.puts('hello world!')
      expect(stdout).to eq ['hello world!', "\e[m\n"]
    end

    it 'prints multiple lines for many strings' do
      NattyUI.puts('hello', 'nice', 'world!')
      expect(stdout).to eq(
        ['hello', "\e[m\n", 'nice', "\e[m\n", 'world!', "\e[m\n"]
      )
    end

    it 'prints multiple lines when strings contain newline' do
      NattyUI.puts("hello\nworld!")
      expect(stdout).to eq ['hello', "\e[m\n", 'world!', "\e[m\n"]
    end

    it 'can ignore newline' do
      NattyUI.puts("hello\n\nworld!\n\n", eol: false)
      expect(stdout).to eq ['hello world!', "\e[m\n"]
    end

    it 'prints a string with prefix and suffix' do
      NattyUI.puts('hello', prefix: '- ', suffix: ' -')
      expect(stdout).to eq ['- ', 'hello', ' -', "\e[m\n"]
    end

    it 'respects the screen columns' do
      NattyUI.puts('helloooo world!', prefix: '- ', suffix: ' -')
      expect(stdout).to eq(
        ['- ', 'helloooo', ' -', "\e[m\n", '- ', 'world!', ' -', "\e[m\n"]
      )
    end

    it 'can align miltiple lines' do
      NattyUI.puts('helloooo world!', prefix: '- ', suffix: ' -', align: :right)
      expect(stdout).to eq(
        [
          '- ',
          '',
          'helloooo',
          ' -',
          "\e[m\n",
          '- ',
          '  ',
          'world!',
          ' -',
          "\e[m\n"
        ]
      )
    end

    it 'interpretes embedded BBCode' do
      NattyUI.puts('[b]hello[/b]', prefix: '[03]-[/fg] ', suffix: ' [03]-[/fg]')
      expect(stdout).to eq(
        [
          "\e[38;5;3m-\e[39m ",
          "\e[1mhello\e[22m",
          " \e[38;5;3m-\e[39m",
          "\e[m\n"
        ]
      )
    end
  end

  context 'when ANSI is not supported' do
    include_context 'with Terminal.rb', ansi: false, size: [25, 14]

    it 'prints a string' do
      NattyUI.puts('hello world!')
      expect(stdoutstr).to eq "hello world!\n"
    end

    it 'prints multiple lines for many strings' do
      NattyUI.puts('hello', 'nice', 'world!')
      expect(stdoutstr).to eq "hello\nnice\nworld!\n"
    end

    it 'prints multiple lines when strings contain newline' do
      NattyUI.puts("hello\nworld!")
      expect(stdout).to eq ['hello', "\n", 'world!', "\n"]
    end

    it 'can ignore newline' do
      NattyUI.puts("hello\n\nworld!\n\n", eol: false)
      expect(stdoutstr).to eq "hello world!\n"
    end

    it 'prints a string with prefix and suffix' do
      NattyUI.puts('hello', prefix: '- ', suffix: ' -')
      expect(stdoutstr).to eq "- hello -\n"
    end

    it 'respects the screen columns' do
      NattyUI.puts('hellooooo world!', prefix: '-- ', suffix: ' --')
      expect(stdoutstr).to eq "-- helloooo --\n-- o world! --\n"
    end

    it 'can align miltiple lines' do
      NattyUI.puts(
        'helloooo world!',
        prefix: '-- ',
        suffix: ' --',
        align: :right
      )
      expect(stdoutstr).to eq "-- helloooo --\n--   world! --\n"
    end

    it 'removes embedded BBCode' do
      NattyUI.puts('[b]hello[/b]', prefix: '[03]-[/fg] ', suffix: ' [03]-[/fg]')
      expect(stdoutstr).to eq "- hello -\n"
    end
  end
end
