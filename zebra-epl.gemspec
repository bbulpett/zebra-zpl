# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zebra/epl/version'

Gem::Specification.new do |spec|
  spec.name          = "zebra-epl"
  spec.version       = Zebra::Epl::VERSION
  spec.authors       = ["Cássio Marques"]
  spec.email         = ["cassiommc@gmail.com"]
  spec.description   = %q{Print labels using EPL2 and Ruby}
  spec.summary       = %q{Simple DSL to create labels and send them to a Zebra printer using Ruby, EPL2 and CUPS}
  spec.homepage      = "http://github.com/cassiomarques/zebra-epl"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "cups"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
