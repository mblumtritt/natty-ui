# frozen_string_literal: true

RSpec.describe NattyUI::Spinner do
  describe '.names' do
    subject(:names) { NattyUI::Spinner.names }

    it 'returns Symbols' do
      expect(names).to all be_a(Symbol)
    end

    it 'returns the names in order' do
      expect(names).to eq names.sort
    end
  end

  describe '.[]' do
    let(:names) { NattyUI::Spinner.names }

    it 'returns a Enumerator for all defined types' do
      expect(names.map { NattyUI::Spinner[_1] }).to all be_a(Enumerator)
    end
  end
end
