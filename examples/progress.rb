# frozen_string_literal: true

require 'natty-ui'

UI = NattyUI::StdOut

UI.space
UI.h1 'NattyUI Progress Indication Demo'
UI.space

# just simulate some work
def something = sleep(0.5)
def some = sleep(0.15)

UI.info 'Tasks are sections to visualize step by step processing.' do |info|
  info.task 'Assemble assets' do |task|
    task.task('Initialize') { something }

    progress = task.progress 'Connect to server...'
    20.times do
      progress.step
      some
    end
    progress.ok 'Connected'

    task.task('Collect files...') { something }

    task.task 'Compile files...' do |subtask|
      %w[readme.txt main.css main.html sub.html].each do |name|
        subtask.msg "Compile file [[bright_yellow]]./source/#{name}[[/]]..."
        something
      end
      subtask.done 'Files compiled.'
    end

    progress = task.progress('Compress files', max_value: 11)
    11.times do
      progress.step
      something
    end
    progress.done 'All compressed'

    task.task('Signing') { something }

    task.task('Store assembled results') { something }
  end
  info.puts(
    'The details are removed ([[italic]]in ANSI version[[/]]) when the task',
    'ended sucessfully.'
  )
end

UI.info 'Details of failed tasks will not be cleaned.' do |info|
  info.task 'Assemble assets' do |task|
    task.task('Initialize') { something }

    progress = task.progress 'Connect to server...'
    20.times do
      progress.step
      some
    end
    progress.failed 'Unable to connect to server'

    task.error 'This code will not be reachd!'
  end
end

UI.space
