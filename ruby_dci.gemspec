lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dci/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_dci"
  spec.version       = ::DCI::VERSION
  spec.authors       = ["Aleksandr Lossenko"]
  spec.email         = ["aleksandr@byteflip.de"]

  spec.summary       = %q{Opinionated DCI implementation for ruby.}
  spec.description   = %q{Opinionated DCI implementation for ruby. Provides base modules for DCI contexts, roles and event processing that should happen outside of the context transaction.}
  spec.homepage      = "https://github.com/egze/ruby_dci"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{lib}/**/*.rb") + ["README.md", "CHANGELOG.md", "Rakefile"]
  spec.test_files    = Dir.glob("spec/**/*")

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_runtime_dependency "rspec-support", "~> 3.7"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.11.3"
end
