# frozen_string_literal: true

require 'natty-ui'

UI = NattyUI::StdOut

UI.write('Natty UI Pgrogress Bar Demo')

def something = sleep(0.3)

UI.progress('Basic Task') do |progression|
  10.times do
    something
    progression.step
  end
end

UI.progress('Task with named steps') do |progression|
  10.times do |i|
    something
    progression.message = "This is the #{i + 1}th step"
  end
  progression.done('Task done')
end

UI.progress('Task percentage view', max_value: 10) do |progression|
  10.times do |i|
    something
    progression.value = i
  end
end

UI.progress('All combined', max_value: 10) do |progression|
  9.times do |i|
    something
    progression.step(message: "This is the #{i + 1}th step", value: i)
  end
  progression.failed('Errro found', 'Sorry, but the task failed')
  raise(NotImplementedError, 'This code will never be reached!')
end
