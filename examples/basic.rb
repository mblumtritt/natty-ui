# frozen_string_literal: true

require 'natty-ui'

UI = NattyUI::StdOut

UI.write('Basic Natty UI Demo', 'This is the demo of very basic UI tools.')

UI.with(:fg_60ff80) { UI.puts <<~TEXT }
  There are different kinds of highlighted sections for different opportunities
  as well as very basic output methods,
TEXT

UI.info('Informational Message', 'Just to your information...')
UI.warn('Warning Message', 'Keep an eye on this...')
UI.err('Error Message', 'Maybe something went wrong...')
