# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "raven-extra"
  spec.version       = "0.0.2"
  spec.authors       = ["John Firebaugh", "Mike Ragalie"]
  spec.email         = ["michael.ragalie@verbasoftware.com"]
  spec.description   = "Adds support for adding extra context to exceptions caught by Raven"
  spec.summary       = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "sentry-raven"
  spec.add_dependency "activesupport", ">= 3.2"
end
