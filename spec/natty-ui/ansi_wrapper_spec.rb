# frozen_string_literal: true

require_relative '../helper'

RSpec.describe 'NattyUI::AnsiWrapper' do
  subject(:ui) { NattyUI.new(stream, ansi: true) }

  let(:stream) { StringIO.new }
  let(:obj) { instance_double(Object, to_s: '-obj-') }

  context '#ansi?' do
    it 'return true' do
      expect(ui.ansi?).to be true
    end
  end

  context '#screen_rows' do
    it 'requests the wrapped stream winsize' do
      expect(stream).to receive(:winsize).once.and_return([42, 21])
      ui.screen_rows
    end

    it 'returns the first winsize member' do
      allow(stream).to receive(:winsize).and_return(%i[first second])
      expect(ui.screen_rows).to be :first
    end
  end

  context '#screen_columns' do
    it 'requests the wrapped stream winsize' do
      expect(stream).to receive(:winsize).once.and_return([42, 21])
      ui.screen_columns
    end

    it 'returns the last winsize member' do
      allow(stream).to receive(:winsize).and_return(%i[first second third])
      expect(ui.screen_columns).to be :third
    end
  end

  context '#screen_size' do
    it 'requests the wrapped stream winsize' do
      expect(stream).to receive(:winsize).once
      ui.screen_size
    end

    it 'returns the winsize result' do
      allow(stream).to receive(:winsize).and_return(:the_result)
      expect(ui.screen_size).to be :the_result
    end
  end

  context '#stream' do
    it 'return the wrapped stream' do
      expect(ui.stream).to be stream
    end
  end

  context '#ask' do
    include_context(
      'ui#ask',
      display: "\e[1;3;38;5;220m▶︎\e[21;23m All fine? \e[0m\e[1K\e[0G"
    )
  end

  context '#done' do
    let(:action) { ui.done('Message Title', "Hello\n World!", 1, obj) }
    let(:output) do
      "\e[1;3;38;5;46m✓\e[21;23m Message Title\e[0m\n  Hello\n" \
        "   World!\n  1\n  -obj-\n"
    end
    include_context 'ui#section'
  end

  context '#err' do
    include_context 'alias', :err, :error
  end

  context '#error' do
    let(:action) { ui.error('Message Title', "Hello\n World!", 1, obj) }
    let(:output) do
      "\e[1;3;38;5;196mX\e[21;23m Message Title\e[0m\n  Hello\n" \
        "   World!\n  1\n  -obj-\n"
    end
    include_context 'ui#section'
  end

  context '#failed' do
    let(:action) { ui.failed('Message Title', "Hello\n World!", 1, obj) }
    let(:output) do
      "\e[1;3;38;5;196mX\e[21;23m Message Title\e[0m\n  Hello\n" \
        "   World!\n  1\n  -obj-\n"
    end
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
    let(:output) do
      "\e[1;3;38;5;39mi\e[21;23m Message Title\e[0m\n  Hello\n" \
        "   World!\n  1\n  -obj-\n"
    end
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
      display:
        "\e[1;3;38;5;220m▶︎\e[21;23m Wanna fruits?\e[0m\n" \
          "  \e[1;4;38;5;231m1\e[0;38;5;255m Apples\e[0m\n" \
          "  \e[1;4;38;5;231m2\e[0;38;5;255m Bananas\e[0m\n" \
          "  \e[1;4;38;5;231mc\e[0;38;5;255m Cherries\e[0m\n" \
          "\e[1;38;5;220m▶︎\e[0m\e[4F\e[0J"
    )
  end

  context '#section' do
    let(:action) { ui.section('Message Title', "Hello\n World!", 1, obj) }
    let(:output) do
      "\e[1;3;38;5;231m•\e[21;23m Message Title\e[0m\n  Hello\n" \
        "   World!\n  1\n  -obj-\n"
    end
    include_context 'ui#section'
  end

  context '#warn' do
    include_context 'alias', :warn, :warning
  end

  context '#warning' do
    let(:action) { ui.warning('Message Title', "Hello\n World!", 1, obj) }
    let(:output) do
      "\e[1;3;38;5;220m!\e[21;23m Message Title\e[0m\n  Hello\n" \
        "   World!\n  1\n  -obj-\n"
    end
    include_context 'ui#section'
  end

  context '#with' do
    it 'writes the related ANSI codes + the ANSI reset code' do
      ui.with(:bold, :blink) do
        # nop
      end
      expect(stream.string).to eq "\e[1;5m\e[0m"
    end

    include_context 'ui#with'
  end

  context '#write' do
    include_context 'alias', :write, :section
  end
end
