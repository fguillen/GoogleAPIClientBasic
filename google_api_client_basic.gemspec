# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_api_client_basic/version'

Gem::Specification.new do |spec|
  spec.name          = "google_api_client_basic"
  spec.version       = GoogleApiClientBasic::VERSION
  spec.authors       = ["Fernando Guillen"]
  spec.email         = ["fguillen.mail@gmail.com"]

  spec.summary       = "Testing Google API Client OAuth autentication"
  spec.homepage      = "https://github.com/fguillen/GoogleApiClientBasic"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # TODO: delete this?
  # spec.add_dependency "googleauth"

  spec.add_dependency "google-api-client", "0.9.pre3" #"0.8.6" #, "0.9.pre1"
  spec.add_dependency "google_drive"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
