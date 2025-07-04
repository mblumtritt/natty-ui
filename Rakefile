# frozen_string_literal: true

$stdout.sync = $stderr.sync = true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:test) { _1.ruby_opts = %w[-w] }

require 'yard'

CLEAN << '.yardoc'
CLOBBER << 'doc'

YARD::Rake::YardocTask.new(:doc) { _1.stats_options = %w[--list-undoc] }

desc 'Run YARD development server'
task('doc:dev' => :clobber) { exec('yard server --reload') }

task(:default) { exec('rake --tasks') }

def generate(fname, content = nil)
  puts "generate #{fname.inspect}"
  File.write(fname, content || yield, mode: 'wx', textmode: true)
end

module Examples
  DIR = './examples'
  FOR = ->(ffn) { ffn.pathmap("#{DIR}/%n%{.*,.rb}x") }
  NAMES = %w[
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

  def self.files
    @files ||= FileList.new(NAMES.map { "#{DIR}/#{_1}.rb" })
  end
end

module Fixtures
  DIR = './spec/fixtures'
  def self.ansi = Examples.files.pathmap("#{DIR}/%n%{.*,.ans}x")
  def self.txt = Examples.files.pathmap("#{DIR}/%n%{.*,.txt}x")
end

directory Fixtures::DIR

namespace :fixtures do
  multitask files: Fixtures.ansi + Fixtures.txt
  task build: [Fixtures::DIR, :files]
  task(:clean) { Rake::Cleaner.cleanup(Fixtures::DIR) }
end

desc 'Rebuild fixtures from samples'
task 'build:fixtures' => %w[fixtures:clean fixtures:build]

rule '.txt' => Examples::FOR do |t|
  generate t.name, `#{FileUtils::RUBY} #{t.prereqs.first}`
end

rule '.ans' => Examples::FOR do |t|
  generate t.name do
    `ANSI=force #{FileUtils::RUBY} #{t.prereqs.first}`.gsub!(/\e\[\?25[lh]/, '')
  end
end
