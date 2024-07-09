# frozen_string_literal: true

RSpec.describe 'NattyUI::Ansi' do
  NattyUI::Ansi.constants.each do |name|
    it "defines #{name} as frozen constant" do
      expect(NattyUI::Ansi.const_get(name)).to be_frozen
    end
  end
end
