# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Tasks[/]' do
  ui.space
  ui.puts <<~TEXT, ignore_newline: true
    Tasks are sections that are closed either successfully or with an error message.
    If successful, their content is only displayed temporarily and can consist of all
    other features, in particular further (sub)tasks. As an exception to this, some
    elements can be “pinned” as permanent content.
  TEXT

  # to simulate some work:
  def foo = sleep(0.25)
  def some = sleep(0.75)

  ui.space
  ui.task 'Actualize Reading List' do
    ui.puts('This is a simple which actualizes the book reading list.')

    ui.task('Connect to Library') do
      foo
      ui.mark('Server Found', mark: :checkmark)
      ui.task('Login...') { some }
    end

    ui.task('Request New Books') { some }

    bar = ui.progress('Loading Books...', pin: true)
    11.times do
      foo
      bar.step
    end
    bar.ok 'Books Loaded'

    ui.task('Disconnect from Library') { some }

    ui.progress('Read Cover Images', max: 11) do |progress|
      while progress.value < progress.max
        foo
        progress.step
      end
    end

    ui.pin('New Books Marked', mark: :checkmark)

    ui.task('Optimize Database') { some }

    ui.task('Remove Dust') { some }
  end
end
