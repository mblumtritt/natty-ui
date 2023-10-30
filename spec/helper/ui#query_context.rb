# frozen_string_literal: true

RSpec.shared_context 'ui#query' do |display:|
  before { allow(NattyUI.in_stream).to receive(:getch).and_return('2') }

  it 'displays the given question' do
    ui.query('Wanna fruits?', 'Apples', 'Bananas', c: 'Cherries')
    expect(stream.string).to eq display
  end

  it 'requests a char from NattyUI.in_stream' do
    expect(NattyUI.in_stream).to receive(:getch).once
    ui.query('Wanna fruits?', 'Apples', 'Bananas')
  end

  it 'returns the pressed char by default' do
    expect(ui.query('Wanna fruits?', 'Apples', 'Bananas')).to eq '2'
  end

  it 'can return the choice' do
    expect(
      ui.query('Wanna fruits?', 'Apples', 'Bananas', result: :choice)
    ).to eq 'Bananas'
  end

  it 'can return the char and the choice' do
    expect(
      ui.query('Wanna fruits?', 'Apples', 'Bananas', result: :both)
    ).to eq %w[2 Bananas]
  end

  it 'returns nil when user aborts with ESC' do
    allow(NattyUI.in_stream).to receive(:getch).and_return("\e")
    expect(ui.query('Wanna fruits?', 'Apples', 'Bananas')).to be nil
  end

  it 'returns nil when user aborts with ^C' do
    allow(NattyUI.in_stream).to receive(:getch).and_return("\u0003")
    expect(ui.query('Wanna fruits?', 'Apples', 'Bananas')).to be nil
  end

  it 'returns nil when user aborts with ^D' do
    allow(NattyUI.in_stream).to receive(:getch).and_return("\u0004")
    expect(ui.query('Wanna fruits?', 'Apples', 'Bananas')).to be nil
  end
end
