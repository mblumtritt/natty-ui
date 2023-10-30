# frozen_string_literal: true

RSpec.shared_context 'ui#puts' do
  it 'prints given arguments as seperate lines' do
    ui.puts('Hello', 'World', 1, obj, 2)
    expect(stream.string).to eq "Hello\nWorld\n1\n-obj-\n2\n"
  end

  it 'optionally limits the output with' do
    ui.puts('Hello' * 5, 'World' * 5, width: 20)
    expect(stream.string).to eq(
      "HelloHelloHelloHello\nHello\nWorldWorldWorldWorld\nWorld\n"
    )
  end

  it 'flushes the output stream' do
    expect(ui.stream).to receive(:flush).once
    ui.puts('test')
  end
end
