# frozen_string_literal: true

FIXTURES = FileList.new

directory 'spec/fixtures'

%w[
  24bit-colors
  3bit-colors
  8bit-colors
  attributes
  attributes_list
  bbcode
  colors_list
  illustration
  ls
  message
  progress
  table
].each do |name|
  FIXTURES << fname = "spec/fixtures/#{name}.ansi"
  file fname => 'spec/fixtures' do |f|
    puts "generate: #{f.name.inspect}"
    File.open(f.name, mode: 'wx', textmode: true) do |file|
      file << `ANSI=1 NO_WAIT=1 #{FileUtils::RUBY} examples/#{name}.rb`
    end
  end
  FIXTURES << fname = "spec/fixtures/#{name}.txt"
  file fname => 'spec/fixtures' do |f|
    puts "generate: #{f.name.inspect}"
    File.open(f.name, mode: 'wx', textmode: true) do |file|
      file << `NO_COLOR=1 NO_WAIT=1 #{FileUtils::RUBY} examples/#{name}.rb`
    end
  end
end

desc 'Build test fixtures'
task 'build:fixtures' => FIXTURES

desc 'Remove test fixtures'
task 'clobber:fixtures' do
  Rake::Cleaner.cleanup_files(FIXTURES)
end
