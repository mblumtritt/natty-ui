# frozen_string_literal: true

# require 'natty-ui'
require_relative '../lib/natty-ui'

UI = NattyUI::StdOut

UI.h1 'NattyUI Progress Indication Demo'
UI.space

# just simulate some work
def something = sleep(0.5)
def some = sleep(0.15)

UI.framed('Pogress Indicators') do |sec|
  progress = sec.progress('Propgress with max_value', max_value: 11)
  11.times do
    progress.step
    some
  end
  progress.done 'Propgress ok'

  progress = sec.progress('Simple propgress')
  20.times do
    progress.step
    some
  end
  progress.done 'Propgress ok'
end

# simulate assembling task steps
def assemble(task)
  task.msg 'Collect files...'
  something
  task.msg 'Compile files...' do |msg|
    msg.puts 'Lala'
    something
    msg.puts 'Lala'
    something
    msg.puts 'Lala'
    something
  end

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
