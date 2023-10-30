# frozen_string_literal: true

require_relative '../helper'

RSpec.describe 'NattyUI::Wrapper' do
  subject(:ui) { NattyUI.new(stream, ansi: false) }

  let(:stream) { StringIO.new }
  let(:obj) { instance_double(Object, to_s: '-obj-') }

  context '#ansi?' do
    it 'return false' do
      expect(ui.ansi?).to be false
    end
  end

  context '#screen_rows' do
    it 'return a build-in constant' do
      expect(ui.screen_rows).to be 25
    end
  end

  context '#screen_columns' do
    it 'return a build-in constant' do
      expect(ui.screen_columns).to be 79
    end
  end

  context '#screen_size' do
    it 'return a build-in value' do
      expect(ui.screen_size).to eq [25, 79]
    end
  end

  context '#stream' do
    it 'return the wrapped stream' do
      expect(ui.stream).to be stream
    end
  end

  context '#ask' do
    include_context 'ui#ask', display: "All fine? \n"
  end

  context '#done' do
    let(:action) { ui.done('Message Title', "Hello\n World!", 1, obj) }
    let(:output) { "✓ Message Title\n  Hello\n  World!\n  1\n  -obj-\n" }
    include_context 'ui#section'
  end

  context '#err' do
    include_context 'alias', :err, :error
  end

  context '#error' do
    let(:action) { ui.error('Message Title', "Hello\n World!", 1, obj) }
    let(:output) { "X Message Title\n  Hello\n  World!\n  1\n  -obj-\n" }
    include_context 'ui#section'
  end

  context '#failed' do
    let(:action) { ui.failed('Message Title', "Hello\n World!", 1, obj) }
    let(:output) { "X Message Title\n  Hello\n  World!\n  1\n  -obj-\n" }
    include_context 'ui#section'
  end

  context '#flush' do
    it 'flushes the output stream' do
      expect(ui.stream).to receive(:flush).once
      ui.flush
    end

    it 'returns itself' do
      expect(ui.flush).to be ui
    end
  end

  context '#info' do
    let(:action) { ui.info('Message Title', "Hello\n World!", 1, obj) }
    let(:output) { "i Message Title\n  Hello\n  World!\n  1\n  -obj-\n" }
    include_context 'ui#section'
  end

  context '#ok' do
    include_context 'alias', :ok, :done
  end

  context '#page' do
    include_context 'ui#page'
  end

  context '#print' do
    include_context 'ui#print'
  end

  context '#progress' do
    context 'without a block' do
      it 'returns a Progression instance' do
        expect(ui.progress('Something')).to be_a NattyUI::Wrapper::Progression
      end
    end

    context 'with a block' do
      it 'yields a Progression instance' do
        ui.progress('Something') do |arg|
          expect(arg).to be_a NattyUI::Wrapper::Progression
        end
      end
    end
  end

  context '#puts' do
    include_context 'ui#puts'
  end

  context '#query' do
    include_context(
      'ui#query',
      display: "▶︎ Wanna fruits?\n  1: Apples\n  2: Bananas\n  c: Cherries\n"
    )
  end

  context '#section' do
    let(:action) { ui.section('Message Title', "Hello\n World!", 1, obj) }
    let(:output) { "• Message Title\n  Hello\n  World!\n  1\n  -obj-\n" }
    include_context 'ui#section'
  end

  context '#warn' do
    include_context 'alias', :warn, :warning
  end

  context '#warning' do
    let(:action) { ui.warning('Message Title', "Hello\n World!", 1, obj) }
    let(:output) { "! Message Title\n  Hello\n  World!\n  1\n  -obj-\n" }
    include_context 'ui#section'
  end

  context '#with' do
    it 'ignores the given arguments' do
      ui.with(:bold, :blink) do
        # nop
      end
      expect(stream.string).to be_empty
    end

    include_context 'ui#with'
  end

  context '#write' do
    include_context 'alias', :write, :section
  end
end
