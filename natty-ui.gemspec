# frozen_string_literal: true

require_relative 'lib/natty-ui/version'

Gem::Specification.new do |spec|
  spec.name = 'natty-ui'
  spec.version = NattyUI::VERSION
  spec.summary = 'The new gem NattyUI.'
  spec.description = <<~DESCRIPTION
    Todo: write a helpful and catchy description
  DESCRIPTION

  spec.author = 'Mike Blumtritt'
  # spec.license = 'BSD-3-Clause'
  spec.homepage = 'https://github.com/mblumtritt/natty-ui'
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['bug_tracker_uri'] = "#{spec.homepage}/issues"
  spec.metadata['documentation_uri'] = 'https://rubydoc.info/gems/natty-ui'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 3.0'
  # spec.add_runtime_dependency 'TODO: add dependencies'

  spec.files = Dir['lib/**/*']
  # spec.executables = %w[command]
  # spec.extra_rdoc_files = %w[README.md LICENSE]
end
