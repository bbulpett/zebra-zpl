# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zebra/zpl/version'

Gem::Specification.new do |spec|
  spec.name          = 'zebra-zpl'
  spec.version       = Zebra::Zpl::VERSION
  spec.authors       = ['Barnabas Bulpett','Michael King','Logan Green']
  spec.email         = ['barnabasbulpett@gmail.com','mtking1123@gmail.com','loganagreen95@gmail.com']
  spec.description   = %q{Print labels using ZPL2 and Ruby}
  spec.summary       = %q{Simple DSL to create labels and send them to a Zebra printer using Ruby, ZPL2 and CUPS}

  spec.homepage      = 'https://github.com/bbulpett/zebra-zpl'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'img2zpl', '~> 1.0.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_development_dependency 'guard', '~> 2.15'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
end
