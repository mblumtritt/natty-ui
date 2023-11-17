# frozen_string_literal: true

$stdout.sync = $stderr.sync = true

require 'bundler/gem_tasks'

CLEAN << '.yardoc'
CLOBBER << 'doc'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:test) { |t| t.ruby_opts = %w[-w] }

require 'yard'

YARD::Rake::YardocTask.new(:doc) { |t| t.stats_options = %w[--list-undoc] }

desc 'Run YARD development server'
task('doc:dev' => :clobber) { exec('yard server --reload') }

task(:default) { exec('rake --tasks') }
