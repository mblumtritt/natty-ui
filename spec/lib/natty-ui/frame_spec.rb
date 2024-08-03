# frozen_string_literal: true

RSpec.describe NattyUI::Frame do
  describe '.names' do
    subject(:names) { NattyUI::Frame.names }

    it 'returns Symbols' do
      expect(names).to all be_a(Symbol)
    end

    it 'returns the names in order' do
      expect(names).to eq names.sort
    end
  end

  describe '.[]' do
    let(:names) { NattyUI::Frame.names }

    it 'returns a String for all defined types' do
      expect(names.map { NattyUI::Frame[_1] }).to all be_a(String)
    end

    it 'returns a String of size 11 for all defined types' do
      expect(names.map { NattyUI::Frame[_1].size }).to all be(11)
    end
  end
end
