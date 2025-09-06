# frozen_string_literal: true

RSpec.describe 'NattyUI feature task' do
  context 'when ANSI is supported' do
    include_context 'with Terminal.rb'

    it 'produces correct output' do
      NattyUI.task('title') { |task| task.puts('content') }
      expect(stdout).to eq(
        [
          "\e[92m➔\e[39m \e[92;1m",
          'title',
          "\e[m\n",
          "\e[?25l",
          '  ',
          'content',
          "\e[m\n",
          "\e[F\e[2K\e[F\e[2K",
          "\e[92m✓\e[39m ",
          'title',
          "\e[m\n",
          "\e[?25h"
        ]
      )
    end
  end
end
