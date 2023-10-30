# frozen_string_literal: true

RSpec.shared_context 'ui#print' do
  it 'prints given arguments' do
    ui.print('Hello', 'World', 1, obj, 2)
    expect(stream.string).to eq 'HelloWorld1-obj-2'
  end

  it 'optionally limits the output with' do
    ui.print('Hello' * 5, 'World' * 5, width: 20)
    expect(stream.string).to eq(
      "HelloHelloHelloHello\nHelloWorldWorldWorld\nWorldWorld\n"
    )
  end

  it 'flushes the output stream' do
    expect(ui.stream).to receive(:flush).once
    ui.print('test')
  end
end
