# frozen_string_literal: true

$stdout.sync = $stderr.sync = $VERBOSE = Warning[:deprecated] = true
RSpec.configure(&:disable_monkey_patching!)

require 'terminal/rspec/helper'
require_relative '../lib/natty-ui'

FIXTURES_DIR = File.expand_path('./fixtures', __dir__).freeze
EXAMPLES_DIR = File.expand_path('../examples', __dir__).freeze
EXAMPLES_NAMES = %w[
  24bit-colors
  3bit-colors
  8bit-colors
  attributes
  cols
  elements
  ls
  named-colors
  sections
  tables
].freeze

def fixture(name) = File.read("#{FIXTURES_DIR}/#{name}")

def example(name)
  load("#{EXAMPLES_DIR}/#{name}.rb")
  stdoutstr
end
