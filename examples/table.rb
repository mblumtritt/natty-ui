# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: Tables'
ui.space

User = Struct.new(:id, :name, :mail, :notes)
users = [
  User.new(
    1,
    'Henry',
    'henry@some.test',
    'This is fill text to generate a wide column ' \
      'which maybe rendered as multi line.'
  ),
  User.new(2, 'Sam', 'sam-sam@some.test', "enforced\nmulti-line"),
  User.new(3, 'Taylor', 'taylor@some.test')
]

ui.message 'Simple Table' do
  ui.space
  ui.table User.members.map(&:capitalize), *users
end

ui.space

ui.message 'Styled Table' do
  users[0].notes = 'Short notice'

  ui.space
  ui.table(expand: true) do |table|
    table.add(User.members.map(&:capitalize), style: 'bold green')
    users.each { |user| table.add(user) }
    table.style_column(0, 'bold green')
    table.align_column(0, :center)
    table.style_row(1000, 'bold green')
  end
end

ui.space
