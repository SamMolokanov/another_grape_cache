
# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "another_grape_cache/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = "another_grape_cache"
  spec.version       = AnotherGrapeCache::VERSION
  spec.authors       = ["Semjon Molokanov"]
  spec.email         = ["molokanovcv@yandex.com"]

  spec.summary       = "Another implementation of Grape Cache"
  spec.description   = "This Gem implements caching for Grape using middlewares and Rails-like caching backend"
  spec.homepage      = "https://github.com/SamMolokanov/another_grape_cache"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 5.2.2"
  spec.add_dependency "grape", "~> 1.2.2"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.56.0"
end
# rubocop:enable Metrics/BlockLength
