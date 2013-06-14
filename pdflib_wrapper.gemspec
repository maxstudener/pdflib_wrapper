$:.push File.expand_path('../lib', __FILE__)
require 'pdflib_wrapper/version'

Gem::Specification.new do |s|
  s.name          = 'pdflib_wrapper'
  s.version       = PdflibWrapper::VERSION
  s.authors       = ['Maxmillian Studener']
  s.email         = 'maxmillian.studener@gmail.com'
  s.homepage      = 'https://github.com/maxstudener/pdflib_wrapper'
  s.summary       = 'Pdflib Wrapper Library'
  s.description   = 'A simple wrapper for more ruby like syntax for pdflib'

  s.rubyforge_project = 'pdflib_wrapper'

  s.files         = `git ls-files`.split('\n')
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'
end
