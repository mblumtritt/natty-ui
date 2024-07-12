# frozen_string_literal: true

require_relative '../lib/natty-ui'

$stdout.sync = $stderr.sync = $VERBOSE = true
RSpec.configure(&:disable_monkey_patching!)

Dir.glob(File.expand_path('./helper/**/*.rb', __dir__)) do |fname|
  require(fname)
end

RUBY = [
  ENV.fetch('RUBY') do
    require('rbconfig')
    File.join(
      RbConfig::CONFIG['bindir'],
      "#{RbConfig::CONFIG['ruby_install_name']}#{RbConfig::CONFIG['EXEEXT']}"
    ).sub(/.*\s.*/m, '"\&"')
  end,
  '--disable-all'
].freeze

def ruby(*args, ansi:)
  system((["#{ansi ? 'ANSI' : 'NO_COLOR'}=1"] + RUBY + args).join(' '))
end

def run_example(name, ansi: true) = ruby("./examples/#{name}.rb", ansi: ansi)

def fixture(name) = File.read(File.join(__dir__, 'fixtures', name))
