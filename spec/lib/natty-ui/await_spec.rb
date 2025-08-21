# frozen_string_literal: true

RSpec.describe 'NattyUI feature await' do
  context 'when ANSI is supported' do
    include_context 'with Terminal.rb'

    it 'returns true for Enter' do
      stdin << "\r"
      expect(NattyUI.await).to be true
    end

    it 'returns false for Esc' do
      stdin << "\e"
      expect(NattyUI.await).to be false
    end

    it 'allows customizing' do
      stdin << '1' << '2'
      expect(NattyUI.await(yes: '1')).to be true
      expect(NattyUI.await(no: '2')).to be false
    end

    it 'allows temporary output' do
      stdin << "\r"
      NattyUI.await { |temp| temp.puts 'TestBlock' }
      expect(stdoutstr).to eq "TestBlock\e[m\n\e[1F\e[J"
    end
  end
end
