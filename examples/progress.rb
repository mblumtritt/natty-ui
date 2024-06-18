# frozen_string_literal: true

require 'natty-ui'

ui.space
ui.h1 'NattyUI Progress Indication Demo'
ui.space

# just simulate some work
def something = sleep(0.5)
def some = sleep(0.15)

ui.info 'Tasks are sections to visualize step by step processing.' do
  ui.task 'Assemble assets' do
    ui.task('Initialize') { something }

    progress = ui.progress 'Connect to server...'
    20.times do
      progress.step
      some
    end
    progress.ok 'Connected'

    ui.task('Collect files...') { something }

    ui.task 'Compile files...' do
      %w[readme.txt main.css main.html sub.html].each do |name|
        ui.msg "Compile file [[bright_yellow]]./source/#{name}[[/]]..."
        something
      end
      ui.done 'Files compiled.'
    end

    progress = ui.progress('Compress files', max_value: 11)
    11.times do
      progress.step
      something
    end
    progress.done 'All compressed'

    ui.task('Signing') { something }

    ui.task('Store assembled results') { something }
  end

  ui.puts(
    'The details are removed ([[italic]]in ANSI version[[/]]) when the task',
    'ended sucessfully.'
  )
end

ui.info 'Details of failed tasks will not be cleaned.' do
  ui.task 'Assemble assets' do
    ui.task('Initialize') { something }
    ui.task('Connect to Server') do
      something
      ui.failed 'Unable to connect to server'
    end
    ui.error 'This code will not be reachd!'
  end
end

ui.space
