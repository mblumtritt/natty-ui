# frozen_string_literal: true

require 'natty-ui'

UI = NattyUI::StdOut

UI.write('Natty UI Query Demo')

exit(false) unless UI.ask('Do you like to continute?')

choice =
  UI.query(
    'Which fruits do you prefer?',
    'Apples',
    'Bananas',
    'Cherries',
    x: 'No fruits',
    result: :choice
  )

unless choice
  UI.failed('Query aborted')
  exit(false)
end

UI.info("Your choice: #{choice}")
