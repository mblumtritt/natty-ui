# frozen_string_literal: true

require 'natty-ui'

User = Struct.new(:id, :name, :address)

USERS = [
  User.new(1, 'Henry', 'henry@some.test'),
  User.new(2, 'Sam', 'sam-sam@some.test'),
  User.new(3, 'Taylor', 'taylor@some.test'),
  User.new(3, 'Max', 'maxxx@some.test')
].freeze

ui.space
ui.h1 'The User List'
ui.space

ui.table(User.members, *USERS)
