# frozen_string_literal: true

RSpec.shared_context 'ui#ask' do |display:|
  before { allow(NattyUI.in_stream).to receive(:getch).and_return('y') }

  it 'displays the given question' do
    ui.ask('All fine?')
    expect(stream.string).to eq display
  end

  it 'requests a char from NattyUI.in_stream' do
    expect(NattyUI.in_stream).to receive(:getch).once
    ui.ask('All fine?')
  end

  it 'returns true when user responds with yes' do
    expect(ui.ask('All fine?')).to be true
  end

  it 'returns false when user responds with no' do
    allow(NattyUI.in_stream).to receive(:getch).and_return('n')
    expect(ui.ask('All fine?')).to be false
  end

  it 'returns nil when user aborts with ESC' do
    allow(NattyUI.in_stream).to receive(:getch).and_return("\e")
    expect(ui.ask('All fine?')).to be nil
  end

  it 'returns nil when user aborts with ^C' do
    allow(NattyUI.in_stream).to receive(:getch).and_return("\u0003")
    expect(ui.ask('All fine?')).to be nil
  end

  it 'returns nil when user aborts with ^D' do
    allow(NattyUI.in_stream).to receive(:getch).and_return("\u0004")
    expect(ui.ask('All fine?')).to be nil
  end

  it 'allows to specify chars to be used for yes' do
    allow(NattyUI.in_stream).to receive(:getch).and_return('a')
    expect(ui.ask('All fine?', yes: 'la')).to be true
  end

  it 'allows to specify chars to be used for no' do
    allow(NattyUI.in_stream).to receive(:getch).and_return('b')
    expect(ui.ask('All fine?', no: 'lb')).to be false
  end

  it 'raises an error when :yes is empty' do
    expect { ui.ask('All fine?', yes: '') }.to raise_error(
      ArgumentError,
      ':yes can not be emoty'
    )
  end

  it 'raises an error when :no is empty' do
    expect { ui.ask('All fine?', no: '') }.to raise_error(
      ArgumentError,
      ':no can not be emoty'
    )
  end

  it 'raises an error when :yes and :no share some chars' do
    expect { ui.ask('All fine?', yes: 'abc', no: 'cde') }.to raise_error(
      ArgumentError,
      /can not be intersect/
    )
  end
end
