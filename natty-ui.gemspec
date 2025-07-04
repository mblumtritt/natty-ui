# frozen_string_literal: true

require_relative 'lib/natty-ui/version'

Gem::Specification.new do |spec|
  spec.name = 'natty-ui'
  spec.version = NattyUI::VERSION
  spec.summary = <<~SUMMARY.tr("\n", ' ')
    This is the beautiful, nice, nifty, fancy, neat, pretty, cool, rich,
    lovely, natty user interface you like to have for your CLI.
  SUMMARY
  spec.description = <<~DESCRIPTION
    This is the beautiful, nice, nifty, fancy, neat, pretty, cool, rich, lovely,
    natty user interface tool you like to have for your command line applications.
    It contains elegant, simple and beautiful features that enhance your
    command line interfaces functionally and aesthetically.
  DESCRIPTION

  spec.author = 'Mike Blumtritt'
  spec.license = 'BSD-3-Clause'
  spec.homepage = 'https://github.com/mblumtritt/natty-ui'
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata[
    'documentation_uri'
  ] = "https://rubydoc.info/gems/natty-ui/#{NattyUI::VERSION}/NattyUI/"

  spec.required_ruby_version = '>= 3.0'
  spec.add_dependency 'terminal_rb', '> 0.9.5'

  spec.files = (Dir['lib/**/*'] + Dir['examples/**/*.rb']) << '.yardopts'
  spec.extra_rdoc_files = %w[README.md LICENSE]
end
