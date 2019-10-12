# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zammad/szpm/version'

Gem::Specification.new do |spec|
  spec.name          = 'zammad-szpm'
  spec.version       = Zammad::SZPM::VERSION
  spec.authors       = ['Thorsten Eckel']
  spec.email         = ['thorsten.eckel@znuny.com']

  spec.summary       = 'This gem provides a class to parse, manipulate and store SZPM files and create ZPM strings from them.'
  spec.homepage      = 'https://github.com/znuny/zammad-szpm'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
end
