# frozen_string_literal: true

require_relative '../helper'

RSpec.describe 'NattyUI::Wrapper' do
  subject(:ui) { NattyUI.new(stream, ansi: false) }

  let(:stream) { StringIO.new }
  let(:obj) { instance_double(Object, to_s: '-obj-') }

  it 'includes NattyUI::Features' do
    expect(ui.class).to include(NattyUI::Features)
  end

  context '#ansi?' do
    it 'returns false' do
      expect(ui.ansi?).to be false
    end
  end

  context '#stream' do
    it 'returns the wrapped stream' do
      expect(ui.stream).to be stream
    end
  end

  context 'when stream supports #winsize' do
    before do
      allow(stream).to receive(:winsize).and_return(
        %i[winsize_first winsize_last]
      )
    end

    it '#screen_size returns winsize' do
      expect(ui.screen_size).to eq %i[winsize_first winsize_last]
    end

    it '#screen_rows returns the first winsize member' do
      expect(ui.screen_rows).to be :winsize_first
    end

    it '#screen_columns returns the first winsize member' do
      expect(ui.screen_columns).to be :winsize_last
    end
  end

  context 'when stream does not support #winsize' do
    context 'when ENV is configured' do
      it "#screen_rows uses ENV['LINES']" do
        expect(ENV).to receive(:[]).with('LINES').once.and_return('42')
        expect(ui.screen_rows).to be 42
      end

      it "#screen_columns uses ENV['COLUMNS']" do
        expect(ENV).to receive(:[]).with('COLUMNS').once.and_return('42')
        expect(ui.screen_columns).to be 42
      end
    end

    context 'when ENV is not configured' do
      it '#screen_rows returns a constant' do
        expect(ui.screen_rows).to be 25
      end

      it '#screen_columns returns a constant' do
        expect(ui.screen_columns).to be 80
      end
    end

    it '#screen_size returns a constant' do
      expect(ui.screen_size).to eq [25, 80]
    end
  end

  context '#puts'
  context '#space'
  context 'page'
  context 'temporary'
end
