lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'literate_maruku/version'

Gem::Specification.new do |spec|
  spec.name          = 'literate_maruku'
  spec.version       = LiterateMaruku::VERSION
  spec.authors       = ['Gregor Schmidt']
  spec.email         = ['schmidt@nach-vorne.eu']

  spec.summary       = 'Literate programming for Ruby based on Maruku.'
  spec.description   = "Given Ruby's open classes and Maruku's powerful parser architecture, literate_maruku provides a basic literate programming environment for Ruby."
  spec.homepage      = 'http://github.com/schmidt/literate_maruku'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z -- README.rdoc lib`.split("\x0")
  spec.executables   = ["literate_maruku"]

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rexml'
  spec.add_runtime_dependency 'maruku', '>= 0.7.0'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit'
end
