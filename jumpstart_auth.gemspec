# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jumpstart_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "jumpstart_auth"
  spec.version       = JumpstartAuth::VERSION
  spec.authors       = ["Jeff Casimir"]
  spec.email         = ["jeff@jumpstartlab.com"]
  spec.summary       = "Authentication library support for JumpstartLab projects"
  spec.description   = "Simplifies authenticating to online services."
  spec.homepage      = "http://github.com/jumpstartlab/jumpstart_auth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "shoulda"

  spec.add_runtime_dependency 'oauth',   '~> 0.4'
  spec.add_runtime_dependency 'twitter', '~> 5.6'
  spec.add_runtime_dependency 'launchy', '~> 2.4'
end
