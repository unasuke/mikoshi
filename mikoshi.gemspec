# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mikoshi/version'

Gem::Specification.new do |spec|
  spec.name          = 'mikoshi'
  spec.version       = Mikoshi::VERSION
  spec.authors       = ['Yusuke Nakamura']
  spec.email         = ['yusuke1994525@gmail.com']

  spec.summary       = 'deploy and manage aws ecs'
  spec.description   = 'Mikoshi is a tool that deploy to ECS and manage task definition and cluster.'
  spec.homepage      = 'https://github.com/unasuke/mikoshi'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_dependency 'activesupport', '~> 5'
  spec.add_dependency 'aws-sdk-ecs', '~> 1'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'codacy-coverage'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'unasukecop'
end
