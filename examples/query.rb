# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: User Queries'
ui.space

# little helper
def abort!
  ui.failed 'aborted'
  ui.space
  exit
end

unless ui.ask('Do you like to continute? (Y|n): ')
  ui.info 'ok, try later!'
  ui.space
  exit
end

choice =
  ui.query(
    'Which fruits do you prefer?',
    'Apples',
    '[yellow]Bananas[/]',
    'Cherries',
    x: 'No fruits'
  )
abort! unless choice
ui.info "Your choice: #{choice}"

answer = ui.request 'What is your favorite verb?: '
abort! unless answer
ui.info "Your answer: #{answer.inspect}"

answer = ui.request('What is your current password?:', password: true)
abort! unless answer
ui.info "I'll keep your secret!"

ui.space
