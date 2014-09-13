# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exceptions/version'

Gem::Specification.new do |spec|
  spec.name          = 'exceptions'
  spec.version       = Exceptions::VERSION
  spec.authors       = ['Eric J. Holmes']
  spec.email         = ['eric@ejholmes.net']
  spec.description   = %q{Exceptions is a Ruby gem for exception tracking.}
  spec.summary       = %q{Exceptions is a Ruby gem for exception tracking.}
  spec.homepage      = 'https://github.com/remind101/exceptions'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'honeybadger', '~> 1.9.5'
end
