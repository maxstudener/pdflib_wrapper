# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdflib_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "pdflib_wrapper"
  spec.version       = PdflibWrapper::VERSION
  spec.authors       = ["Max Studener"]
  spec.email         = ["maxmillian.studener@gmail.com"]
  spec.summary       = 'Pdflib Wrapper Library'
  spec.description   = 'A simple wrapper for more ruby like syntax for pdflib'
  spec.homepage      = "https://github.com/maxstudener/pdflib_wrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake" 
  spec.add_development_dependency "rspec"
end
