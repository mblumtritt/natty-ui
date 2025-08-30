# frozen_string_literal: true

RSpec.describe 'NattyUI feature puts' do
  context 'when ANSI is supported' do
    include_context 'with Terminal.rb'

    {
      ['Hello [b]World[/b]', {}] => "Hello \e[1mWorld\e[22m\e[m\n",
      ['Hello World', { prefix: '😀' }] => "😀Hello World\e[m\n",
      ['Hello', 'World', { prefix: '😀' }] => "😀Hello\e[m\n😀World\e[m\n",
      ['Hello', 'World', { first_line_prefix: '😀' }] =>
        "😀Hello\e[m\n  World\e[m\n",
      ['Hello', 'World', { suffix: '😀' }] => "Hello😀\e[m\nWorld😀\e[m\n",
      ['Hello World', { align: :centered, expand: true }] =>
        "#{' ' * 34}Hello World#{' ' * 35}\e[m\n",
      ['Hello World', { align: :right, expand: true }] =>
        "#{' ' * 69}Hello World\e[m\n",
      ['Hello World', { align: :right, expand: true, max_width: 60 }] =>
        "#{' ' * 49}Hello World\e[m\n",
      ['Hello World', { align: :right, expand: true, max_width: 0.5 }] =>
        "#{' ' * 29}Hello World\e[m\n",
      ['Hello World', { align: :right, expand: true, max_width: 0 }] => '',
      ["\n\nHello\nWorld\n\n", { eol: false }] => "Hello World\e[m\n"
    }.each_pair do |args, expected|
      *args, kwargs = *args
      it "writes #{args.map(&:inspect).join(', ')}, #{kwargs.inspect[1..-2]}" do
        stdout.clear
        NattyUI.puts(*args, **kwargs)
        expect(stdoutstr).to eq expected
      end
    end
  end
end
