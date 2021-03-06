# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moneyball/version'

Gem::Specification.new do |spec|
  spec.name          = "moneyball"
  spec.version       = Moneyball::VERSION
  spec.authors       = ["Jeremy Ward"]
  spec.email         = ["jeremy.ward@digital-ocd.com"]
  spec.summary       = %q{CLI application that will be used to provide information about baseball player statistics}
  spec.description   = %q{CLI application that will be used to provide information about baseball player statistics}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'commander'
  spec.add_runtime_dependency 'activerecord'
  spec.add_runtime_dependency 'sqlite3'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'factory_girl', "~> 4.0"
  spec.add_development_dependency "database_cleaner"
end
