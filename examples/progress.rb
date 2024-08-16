# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: Progress Indication', space: 2

# just simulate some work
if ENV.key?('NO_WAIT')
  def something = nil
  def some = nil
else
  def something = sleep(0.5)
  def some = sleep(0.15)
end

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
        ui.msg "Compile file [bright_yellow]./source/#{name}[/]...", glyph: :dot
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
    'The details are removed ([i]in ANSI version[/i]) when the task',
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
