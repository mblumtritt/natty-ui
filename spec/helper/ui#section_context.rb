# frozen_string_literal: true

RSpec.shared_context 'ui#section' do
  # requires `action`, `output`
  it 'writes a message block' do
    action
    expect(stream.string).to eq output
  end

  it 'flushes the output stream' do
    expect(ui.stream).to receive(:flush).once
    action
  end

  it 'returns itself' do
    expect(action).to be ui
  end
end
