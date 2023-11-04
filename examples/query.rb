# frozen_string_literal: true

# require 'natty-ui'
require_relative '../lib/natty-ui'

UI = NattyUI::StdOut

UI.framed('NattyUI Query Demo') do |sec|
  unless sec.ask('Do you like to continute? (Y|n)')
    sec.failed('aborted')
    sec.close
    exit
  end

  choice =
    sec.query(
      'Which fruits do you prefer?',
      'Apples',
      'Bananas',
      'Cherries',
      x: 'No fruits',
      result: :choice
    )
  unless choice
    sec.failed('aborted')
    sec.close
    exit(false)
  end
  sec.info("Your choice: #{choice}")
end
