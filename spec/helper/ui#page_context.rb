# frozen_string_literal: true

RSpec.shared_context 'ui#page' do
  it 'yields itself' do
    ui.page { |arg| expect(arg).to be ui }
  end

  it 'returns the block result' do
    expect(ui.page { :result }).to be :result
  end

  it 'flushes the output stream' do
    expect(ui.stream).to receive(:flush).at_least(1)
    ui.page do
      # nop
    end
  end
end
