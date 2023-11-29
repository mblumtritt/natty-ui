# frozen_string_literal: true

require 'natty-ui'

UI = NattyUI::StdOut

UI.space
UI.h1 'NattyUI Query Demo'
UI.space

unless UI.ask('Do you like to continute? (Y|n)')
  UI.failed 'aborted'
  exit
end

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
  UI.failed 'aborted'
  exit false
end
UI.info "Your choice: #{choice}"

answer = UI.request 'Are you okay?'
unless answer
  UI.failed 'aborted'
  exit false
end
UI.info "Your answer: #{answer.inspect}"

answer = UI.request('What is your current password?', password: true)
unless answer
  UI.failed 'aborted'
  exit false
end
UI.info "I'll keep your secret!"
