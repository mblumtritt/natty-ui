# frozen_string_literal: true

require_relative 'helper'

RSpec.describe NattyUI do
  describe '.in_stream' do
    it 'is STDIN by default' do
      expect(subject.in_stream).to be STDIN
    end

    it 'accepts readable stream' do
      expect { NattyUI.in_stream = StringIO.new }.not_to raise_error
    end

    it 'raises for invalid stream' do
      stream = StringIO.new
      stream.close_read
      expect { NattyUI.in_stream = stream }.to raise_error(TypeError)
    end
  end

  describe 'StdOut' do
    subject(:stdout) { NattyUI::StdOut }

    it 'is a Wrapper' do
      expect(subject).to be_a NattyUI::Wrapper
    end

    it 'uses STDOUT' do
      expect(subject.stream).to be STDOUT
    end
  end

  describe 'StdErr' do
    subject(:stderr) { NattyUI::StdErr }

    it 'is a Wrapper' do
      expect(subject).to be_a NattyUI::Wrapper
    end
  end

  describe '.valid_out?' do
    it 'returns true for a writable IO stream' do
      IO.pipe { |_, stream| expect(NattyUI.valid_out?(stream)).to be true }
    end

    it 'returns true for a writable StringIO' do
      expect(NattyUI.valid_out?(StringIO.new)).to be true
    end

    it 'returns false if the IO stream is not writable' do
      IO.pipe do |_, stream|
        stream.close_write
        expect(NattyUI.valid_out?(stream)).to be false
      end
    end

    it 'returns false if the StringIO stream is not writable' do
      expect(NattyUI.valid_out?(StringIO.new(''))).to be false
    end

    it 'returns false for other object types' do
      expect(NattyUI.valid_out?(Object.new)).to be false
    end
  end

  describe '.valid_in?' do
    it 'returns true for a readable IO stream' do
      IO.pipe { |stream, _| expect(NattyUI.valid_in?(stream)).to be true }
    end

    it 'returns true for a readable StringIO' do
      expect(NattyUI.valid_in?(StringIO.new)).to be true
    end

    it 'returns false if the IO stream is not readable' do
      IO.pipe do |_, stream|
        stream.close_write
        expect(NattyUI.valid_in?(stream)).to be false
      end
    end

    it 'returns false if the StringIO stream is not readable' do
      stream = StringIO.new
      stream.close_read
      expect(NattyUI.valid_in?(stream)).to be false
    end

    it 'returns false for other object types' do
      expect(NattyUI.valid_in?(Object.new)).to be false
    end
  end

  describe '.embellish' do
    it 'translates embedded ANSI attributes' do
      expect(
        NattyUI.embellish('[[bold]]Hello [[blink ff00ff onfafafa]]World[[/]]!')
      ).to eq "\e[1mHello \e[5;38;2;255;0;255;48;2;250;250;250mWorld\e[0m!"
    end

    it 'respects escaped and invalid attributes' do
      expect(NattyUI.embellish('[[/some test]] [[another test]]')).to eq(
        '[[some test]] [[another test]]'
      )
    end
  end

  describe '.plain' do
    it 'removes embedded ANSI attributes' do
      expect(
        NattyUI.plain('[[bold]]Hello [[blink ff00ff onfafafa]]World[[/]]!')
      ).to eq('Hello World!')
    end

    it 'does not remove escaped and invalid attributes' do
      expect(NattyUI.plain('[[/some test]] [[another test]]')).to eq(
        '[[some test]] [[another test]]'
      )
    end
  end

  describe '.display_width' do
    it 'returns the correct dislay width of a given string' do
      expect(NattyUI.display_width('123❌67890')).to be 10
    end
  end

  describe '.new' do
    context 'when ansi parameter is true' do
      it 'creates a wrapper with ANSI support' do
        expect(NattyUI.new(StringIO.new, ansi: true).ansi?).to be true
      end
    end

    context 'when ansi parameter is false' do
      it 'creates a non-ANSI wrapper' do
        expect(NattyUI.new(StringIO.new, ansi: false).ansi?).to be false
      end
    end

    context 'without ansi parameter' do
      let(:ansi_stream) { Class.new(StringIO) { def tty? = true }.new }

      it 'creates a wrapper with ANSI support depending on given stream' do
        expect(NattyUI.new(StringIO.new).ansi?).to be false
        expect(NattyUI.new(ansi_stream).ansi?).to be true
      end
    end

    context 'when a invalid stream is given' do
      it 'raises a TypeError' do
        expect { NattyUI.new(StringIO.new('')) }.to raise_error(TypeError)
      end
    end
  end
end
