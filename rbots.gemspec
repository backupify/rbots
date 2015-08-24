# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbots/version'

Gem::Specification.new do |spec|
  spec.name          = "rbots"
  spec.version       = Rbots::VERSION
  spec.authors       = ["Danny Guinther"]
  spec.email         = ["dguinther@datto.com"]

  spec.summary       = %q{Multibot robut}
  spec.description   = %q{Multibot robut}
  spec.homepage      = "https://github.com/backupify/rbots"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "minitest", "> 3.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "hipchat", "~> 1.2.0"
  spec.add_dependency "robut", "~> 0.5.2"
end
