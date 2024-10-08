# frozen_string_literal: true

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

  describe '.embellish' do
    it 'translates embedded ANSI attributes' do
      expect(
        NattyUI.embellish('[b]Hello[/b] [blink ff00ff onfafafa]World[/]!')
      ).to eq "\e[1mHello\e[22m \e[5;38;2;255;0;255;48;2;250;250;250mWorld\e[m!"
    end

    it 'respects escaped and invalid attributes' do
      expect(
        NattyUI.embellish('[bold unknown] [//bold italic] [//b] [///b]')
      ).to eq('[bold unknown] [/bold italic] [/b] [//b]')
    end
  end

  describe '.plain' do
    let(:all_attributes) do
      (NattyUI::Ansi.attribute_names + NattyUI::Ansi.color_names)
    end

    it 'removes embedded ANSI attributes' do
      expect(NattyUI.plain('[b]Hello [blink ff00ff onfafafa]World[/]!')).to eq(
        'Hello World!'
      )
    end

    it 'removes all supported attributes' do
      str = all_attributes.map { "[#{_1}]C" }.join
      expect(NattyUI.plain(str)).to eq('C' * all_attributes.size)
    end

    it 'does not remove escaped and invalid attributes' do
      expect(
        NattyUI.plain(
          "\e[1K\e[0G[b][i][bold unknown] [//bold italic] [//b] [///b][/b][/i]"
        )
      ).to eq("\e[1K\e[0G[bold unknown] [/bold italic] [/b] [//b]")
    end

    it 'removes ANSI control codes too' do
      expect(
        NattyUI.plain(
          "\e[1K\e[0G[b][i][bold unknown] [//bold italic] [//b] [///b][/b][/i]",
          ansi: :remove
        )
      ).to eq('[bold unknown] [/bold italic] [/b] [//b]')
    end

    it 'removes all supported ANSI control codes' do
      str = all_attributes.map { "#{NattyUI::Ansi[_1]}C" }.join
      expect(NattyUI.plain(str, ansi: :remove)).to eq('C' * all_attributes.size)
    end
  end

  describe '.display_width' do
    it 'returns the correct dislay width of a given string' do
      sample = "\e[s123❌67[bold]8⛽[curly_underline afa]コンニチハ⚾️"
      expect(NattyUI.display_width(sample)).to be 22
    end

    context '[east asian width]' do
      [
        ['F', 2, '！'],
        ['W', 2, '一'],
        ['W (unassigned)', 2, "\u{3FFFD}"],
        ['N', 1, 'À'],
        ['Na', 1, 'A'],
        ['H', 1, '｡'],
        ['A', 1, '·']
      ].each do |(name, width, char)|
        it "returns #{width} for #{name}" do
          expect(NattyUI.display_width(char)).to eq width
        end
      end
    end

    context '[zero width]' do
      [
        %w[Mn ֿ],
        ['buhid vowel sign', "\u{1752}"],
        ['lepcha sign ran', "\u{1c36}"],
        ['dives akuru sign anusvara', "\u{1193b}"],
        ['adlam nukta', "\u{1e94a}"],
        ['variation selector-256', "\u{e01ef}"]
      ].each do |(name, char)|
        it "returns 0 for #{name}" do
          expect(NattyUI.display_width(char)).to be_zero
        end
      end
    end

    context '[special characters]' do
      [
        ['␀', "\0"],
        ['␅', "\x05"],
        ['␇', "\a"],
        ['␈', "\b"],
        ['␊', "\n"],
        ['␋', "\v"],
        ['␌', "\f"],
        ['␍', "\r"],
        ['␎', "\x0E"],
        ['␏', "\x0F"]
      ].each do |(name, char)|
        it "returns 0 for #{name} (##{char.ord})" do
          expect(NattyUI.display_width(char)).to be_zero
        end
      end

      # what about "a\b"

      "\x01\x02\x03\x04\x06\x10\x11\x12\x13\x14\x15\x16" \
        "\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x7f".each_char do |char|
        it "returns 1 for C0 character ##{char.ord} #{char.inspect}" do
          expect(NattyUI.display_width(char)).to eq 1
        end
      end

      [
        ['SOFT HYPHEN', 1, '­']
        # ['THREE-EM DASH', 2, '⸺']
        # ['THREE-EM DASH', 3, '⸻']
      ].each do |(name, width, char)|
        it "returns #{width} for #{name}" do
          expect(NattyUI.display_width(char)).to eq width
        end
      end
    end

    context '[emoji]' do
      it 'does not count modifiers and zjw sequences for valid emoji' do
        expect(NattyUI.display_width('🤾🏽‍♀️')).to eq 2
      end

      it 'works with flags' do
        expect(NattyUI.display_width('🇦🇨🇵🇹🇧🇷')).to eq 6
      end
    end
  end

  xdescribe '.each_line' do
    # TODO
  end
end
