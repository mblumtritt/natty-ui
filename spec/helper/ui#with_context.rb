# frozen_string_literal: true

RSpec.shared_context 'ui#with' do
  it 'yields itself' do
    ui.with(:bold, :blink) { |arg| expect(arg).to be ui }
  end

  it 'returns the block result' do
    expect(ui.with(:bold, :blink) { :result }).to be :result
  end

  it 'flushes the output stream' do
    expect(ui.stream).to receive(:flush).once
    ui.with(:bold, :blink) do
      # nop
    end
  end
end
