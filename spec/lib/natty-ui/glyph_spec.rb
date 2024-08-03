# frozen_string_literal: true

RSpec.describe NattyUI::Glyph do
  describe '.names' do
    subject(:names) { NattyUI::Glyph.names }

    it 'returns Symbols' do
      expect(names).to all be_a(Symbol)
    end

    it 'returns the names in order' do
      expect(names).to eq names.sort
    end
  end

  describe '.[]' do
    let(:names) { NattyUI::Glyph.names }

    it 'returns a String for all defined types' do
      expect(names.map { NattyUI::Glyph[_1] }).to all be_a(String)
    end
  end
end
