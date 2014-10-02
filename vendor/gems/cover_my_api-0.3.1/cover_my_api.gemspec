# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cover_my_api/version"

Gem::Specification.new do |spec|
  spec.name          = "cover_my_api"
  spec.version       = CoverMyApi::VERSION
  spec.authors       = ["Justin Rolston"]
  spec.email         = ["jrolston@covermymeds.com"]
  spec.description   = %q{cover_my_api is a gem that provides Ruby client for api.covermymeds.com}
  spec.summary       = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock", "~> 1.11"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "rest-client", "~> 1.6"
  spec.add_runtime_dependency "hashie", "~> 2.0.2"
  spec.add_runtime_dependency "settingslogic"
  spec.add_runtime_dependency "activesupport"
end
