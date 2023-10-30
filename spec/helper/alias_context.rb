# frozen_string_literal: true

RSpec.shared_context 'alias' do |alias_name, orginal_name|
  it "is an alias for ##{orginal_name}" do
    expect(ui.method(alias_name)).to eq ui.method(orginal_name)
  end
end
