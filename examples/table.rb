# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.space
ui.h1 'NattyUI: Tables'
ui.space

ui.message 'Constructed Table' do
  ui.table type: :heavy do |table|
    table.add 'X', 'O'
    table.add 'O', 'O', 'X'
    table.add nil, 'X'
  end
end

ui.space

User = Struct.new(:id, :name, :mail, :notes)
USERS = [
  User.new(
    1,
    'Henry',
    'henry@some.test',
    'This is fill text to generate a wide column which maybe rendered as multi line.'
  ),
  User.new(2, 'Sam', 'sam-sam@some.test', "enforced\nmulti-line"),
  User.new(3, 'Taylor', 'taylor@some.test'),
  User.new(3, 'Max', 'maxxx@some.test')
].freeze

ui.message 'Data Table' do
  ui.table(User.members, *USERS)
end

ui.space
