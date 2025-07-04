# frozen_string_literal: true

RSpec.describe 'examples' do
  include_context 'with Terminal.rb'

  EXAMPLES_NAMES.each do |name|
    it "renders the '#{name}.rb' example" do
      expect(example(name)).to eq fixture("#{name}.ans")
    end
  end

  context 'when Ansi is not supported' do
    include_context 'with Terminal.rb', ansi: false

    EXAMPLES_NAMES.each do |name|
      it "renders the '#{name}.rb' example as text only" do
        expect(example(name)).to eq fixture("#{name}.txt")
      end
    end
  end
end
