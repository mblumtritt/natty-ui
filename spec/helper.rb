# frozen_string_literal: true

require_relative '../lib/natty-ui'
require_relative '../lib/natty-ui/version'

$stdout.sync = $stderr.sync = $VERBOSE = true
RSpec.configure(&:disable_monkey_patching!)
def fixture(name) = File.read(File.join(__dir__, 'fixtures', name))
def run_example(name, ansi: true) = ruby("./examples/#{name}.rb", ansi: ansi)

def ruby(*args, ansi:)
  cmd = ["#{ansi ? 'ANSI' : 'NO_COLOR'}=1", 'NO_WAIT=1', RUBY]
  `#{(cmd + args).join(' ')}`
end

RUBY =
  ENV
    .fetch('RUBY') do
      require('rbconfig')
      File.join(
        RbConfig::CONFIG['bindir'],
        "#{RbConfig::CONFIG['ruby_install_name']}#{RbConfig::CONFIG['EXEEXT']}"
      ).sub(/.*\s.*/m, '"\&"')
    end
    .freeze
