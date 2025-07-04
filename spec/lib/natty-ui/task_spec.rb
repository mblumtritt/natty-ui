# frozen_string_literal: true

RSpec.describe 'NattyUI feature task' do
  context 'when ANSI is supported' do
    include_context 'with Terminal.rb'

    it 'out' do
      NattyUI.task('title') { |task| task.puts('content') }
      expect(stdout).to eq(
        [
          "\e[92;1m➔ ",
          'title',
          "\e[m\n",
          '  ',
          'content',
          "\e[m\n",
          "\e[F\e[2K\e[F\e[2K",
          "\e[92m✓\e[39m ",
          'title',
          "\e[m\n"
        ]
      )
    end
  end
end
