# frozen_string_literal: true

require_relative '../helper'

RSpec.describe 'NattyUI::AnsiWrapper' do
  subject(:ui) { NattyUI.new(stream, ansi: true) }

  let(:stream) { StringIO.new }
  let(:obj) { instance_double(Object, to_s: '-obj-') }

  it 'inherits from NattyUI::Wrapper' do
    expect(ui.class.superclass).to be NattyUI::Wrapper
  end

  context '#ansi?' do
    it 'returns true' do
      expect(ui.ansi?).to be true
    end
  end

  context 'page'
end
