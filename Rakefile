# frozen_string_literal: true

$stdout.sync = $stderr.sync = true

require 'bundler/gem_tasks'

CLEAN << '.yardoc'
CLOBBER << 'doc'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:test) { _1.ruby_opts = %w[-w] }

require 'yard'

YARD::Rake::YardocTask.new(:doc) { _1.stats_options = %w[--list-undoc] }

desc 'Run YARD development server'
task('doc:dev' => :clobber) { exec('yard server --reload') }

task(:default) { exec('rake --tasks') }

directory './spec/fixtures'
FIXTURES = FileList.new

%w[
  3bit-colors
  8bit-colors
  24bit-colors
  attributes
  attributes_list
  illustration
  ls
  message
  table
].each do |name|
  FIXTURES << fname = "./spec/fixtures/#{name}.ansi"
  file fname => './spec/fixtures' do |f|
    puts "generate: #{f.name.inspect}"
    File.open(f.name, mode: 'wx', textmode: true) do |file|
      file << `ANSI=1 #{FileUtils::RUBY} ./examples/#{name}.rb`
    end
  end
  FIXTURES << fname = "./spec/fixtures/#{name}.txt"
  file fname => './spec/fixtures' do |f|
    puts "generate: #{f.name.inspect}"
    File.open(f.name, mode: 'wx', textmode: true) do |file|
      file << `NO_COLOR=1 #{FileUtils::RUBY} ./examples/#{name}.rb`
    end
  end
end

desc 'Remove test fixtures'
task 'clobber:fixtures' do
  Rake::Cleaner.cleanup_files(FIXTURES)
end

desc 'Build test fixtures'
task 'build:fixtures' => FIXTURES
