# frozen_string_literal: true

require_relative 'lib/pronto/bigfiles/version'

Gem::Specification.new do |spec|
  spec.name          = 'pronto-bigfiles'
  spec.version       = Pronto::BigFilesVersion::VERSION
  spec.authors       = ['Vince Broz']
  spec.email         = ['vince@broz.cc']

  spec.summary       = 'Pronto plugin for the bigfiles gem'
  spec.description   = <<~DESCRIPTION
    Performs incremental quality reporting for the bigfiles gem.
    BigFiles is a simple tool to find the largest source files in your
    project; this gem plugs in with the 'pronto' gem, which does
    incremental reporting using a variety of quality tools.
  DESCRIPTION
  spec.homepage      = 'https://github.com/apiology/pronto-bigfiles'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] =
    'https://github.com/apiology/pronto-bigfiles'

  # Specify which files should be added to the gem when it is
  # released.  The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bigfiles', '>=0.2.0'
  spec.add_dependency 'pronto'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pronto-punchlist'
  spec.add_development_dependency 'pronto-rubocop'
  spec.add_development_dependency 'quality', '~> 37'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
end
