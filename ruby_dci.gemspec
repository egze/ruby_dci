lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dci/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby_dci"
  spec.version       = ::DCI::VERSION
  spec.authors       = ["Aleksandr Lossenko"]
  spec.email         = ["aleksandr@byteflip.de"]

  spec.summary       = %q{Opinionated DCI implementation for ruby.}
  spec.description   = %q{Provides base modules for DCI contexts, roles and event processing that should happen outside of the context transaction.}
  spec.homepage      = "https://github.com/egze/ruby_dci"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
