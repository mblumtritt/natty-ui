# frozen_string_literal: true

desc 'Build east asian width file'
task 'build:eaw' => 'lib/natty-ui/text/east_asian_width.rb'

desc 'Remove east asian width file'
task 'clobber:eaw' do
  Rake::Cleaner.cleanup_files(['lib/natty-ui/text/east_asian_width.rb'])
end

directory 'tmp'
CLEAN << 'tmp'

directory 'lib/natty-ui/text'

file 'tmp/EastAsianWidth.txt' => 'tmp' do
  Dir.chdir('./tmp') do
    sh 'curl -O https://www.unicode.org/Public/UNIDATA/EastAsianWidth.txt'
  end
end

file(
  'lib/natty-ui/text/east_asian_width.rb' => %w[
    lib/natty-ui/text
    tmp/EastAsianWidth.txt
  ]
) do |f|
  puts "generate: #{f.name.inspect}"
  File.open(f.name, mode: 'wx', textmode: true) do |file|
    file.puts EastAsianWidth.from_file('tmp/EastAsianWidth.txt')
  end
end

task :eaw do
  puts EastAsianWidth.from_file('tmp/EastAsianWidth.txt')
end

module EastAsianWidth
  def self.from_file(fname)
    map = read_map(fname)
    <<~RUBY
      # frozen_string_literal: true

      module NattyUI
        module Text
          module EastAsianWidth
            def self.[](ord) = WIDTH[LAST.bsearch_index { ord <= _1 }]

            LAST = [
      #{map.keys.map! { "        0x#{_1.to_s(16)}" }.join(",\n")}
            ].freeze

            WIDTH = [
      #{map.values.map! { "        #{_1}" }.join(",\n")}
            ].freeze
          end
        end
      end
    RUBY
  end

  def self.read_map(fname)
    widths = []
    File.foreach(fname, chomp: true) do |line|
      match = RE_DEFINITION.match(line) or next
      width = match[:cat] == 'Mn' ? 0 : TYPE[match[:type]]
      raise("unknown width type identifier - #{line.inspect}") unless width
      widths.fill(
        width,
        match[:first].to_i(16)..(match[:last] || match[:first]).to_i(16)
      )
    end
    widths.fill(2, 0x1f1e6..0x1f1ff) # regional indicator symbols
    map =
      widths
        .each_with_index
        .chunk { |width, _idx| width || 1 }
        .to_h { |width, chunk| [chunk.last.last, width] }
    # additions
    map[0xfffff] ||= 1
    map[0x10fffd] ||= -1
    map[0x7fffffff] ||= 1
    map
  end

  RE_DEFINITION =
    /^(?<first>\h+)(?:\.\.(?<last>\h+))?\s*;\s*(?<type>\w+)\s+#\s+(?<cat>[^ ]+)/
  TYPE = { 'N' => 1, 'H' => 1, 'Na' => 1, 'F' => 2, 'W' => 2, 'A' => -1 }.freeze
end
