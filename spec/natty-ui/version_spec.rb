# frozen_string_literal: true

require_relative '../helper'

RSpec.describe 'NattyUI::VERSION' do
  subject(:version) { NattyUI::VERSION }
  it { is_expected.to match(/\A[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\z/) }
  it { is_expected.to be_frozen }
end
