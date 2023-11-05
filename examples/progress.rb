# frozen_string_literal: true

# require 'natty-ui'
require_relative '../lib/natty-ui'

UI = NattyUI::StdOut

UI.h1 'NattyUI Progress Indication Demo'
UI.space

# just simulate some work
def something = sleep(0.5)

# simulate assembling task steps
def assemble(task)
  task.msg 'Collect files...'
  something
  task.msg 'Compile files...'
  something
  task.msg 'Compressing...'
  something
  task.msg 'Signing...'
  something
  task.msg 'Store assembled results...'
  something
end

UI.framed('Tasks') do |sec|
  sec.puts 'Tasks are sections to visualize step by step processing.'
  sec.task('Assemble assets') { |task| assemble(task) }
  sec.space

  sec.puts 'If such a task failed the logged messages are kept:'
  assembling = sec.task('Assemble assets')
  assemble(assembling)
  assembling.failed
  sec.space

  sec.puts 'You can add some more description when failed:'
  sec.task('Assemble assets') do |task|
    assemble(task)
    task.failed('Unable to store results', <<~ERROR)
      Server reported Invalid credentials
      Check your credentials and try again...
    ERROR

    This code here is never reached!
  end
  sec.space

  sec.puts 'You can also add a description when all was fine:'
  sec.task('Assemble assets') do |task|
    assemble(task)
    task.done('Assets assembled', <<~INFO)
      Your assets are ready on server now.
    INFO

    This code here is never reached!
  end
end

__END__

UI.write('Natty UI Pgrogress Bar Demo')

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
