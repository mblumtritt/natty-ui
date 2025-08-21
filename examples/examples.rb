# frozen_string_literal: true

require_relative '../lib/natty-ui'

EXAMPLES = {
  'info' => 'Terminal Information',
  'attributes' => 'ANSI Attributes',
  '3bit-colors' => '3/4bit Color Support',
  '8bit-colors' => '8bit Color Support',
  '24bit-colors' => '24bit Color Support',
  'named-colors' => 'Named Colors Support',
  'elements' => 'Simple Elements',
  'ls' => 'Print Lists',
  'tables' => 'Print Tables',
  'cols' => 'Print Columns',
  'vbars' => 'Print Vertical Bars',
  'hbars' => 'Print Horizontal Bars',
  'sections' => 'Sections',
  'tasks' => 'Tasks',
  'options' => 'Options and Selections'
}.freeze

ui.space

while true
  selected =
    ui.choice(**EXAMPLES, abortable: true, selected: selected) do
      ui.cols(
        "[red] /\\_/\\\n( o.o )\n > ^ <",
        '[bright_green b]Select a natty example:',
        width: 8
      )
      ui.div('[faint](Abort with [\\ESC])', padding: [1, 0, 1])
    end

  ui.space unless Terminal.ansi?
  break unless selected

  ui.temporary do
    load("#{__dir__}/#{selected}.rb")
    if Terminal.ansi?
      ui.await { ui.puts '[faint][\\Press ENTER to continue...]' }
    else
      ui.space
    end
  end
end
