# frozen_string_literal: true

require_relative '../helper'

RSpec.describe 'NattyUI::VERSION' do
  subject(:version) { NattyUI::VERSION }

  it { is_expected.to be_frozen }
  it do
    is_expected.to match(
      /\A[[:digit:]]{1,3}.[[:digit:]]{1,3}.[[:digit:]]{1,3}(alpha|beta)?\z/
    )
  end
end
