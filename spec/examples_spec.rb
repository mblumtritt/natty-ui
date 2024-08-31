# frozen_string_literal: true

RSpec.describe 'examples' do
  %w[
    24bit-colors
    3bit-colors
    8bit-colors
    attributes
    attributes_list
    bbcode
    colors_list
    columns
    illustration
    ls
    message
    progress
    table
  ].each do |name|
    it "generates ANSI version of #{name}" do
      expect(run_example(name)).to eq fixture("#{name}.ansi")
    end

    it "generates a non-colored version of #{name}" do
      expect(run_example(name, ansi: false)).to eq fixture("#{name}.txt")
    end
  end
end
