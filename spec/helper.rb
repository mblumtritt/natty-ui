# frozen_string_literal: true

require 'rspec/core'
require_relative '../lib/natty-ui'

$stdout.sync = $stderr.sync = $VERBOSE = true
RSpec.configure(&:disable_monkey_patching!)

Dir.glob(File.expand_path('./helper/**/*.rb', __dir__)) do |fname|
  require(fname)
end
