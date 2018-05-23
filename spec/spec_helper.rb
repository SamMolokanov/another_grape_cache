# frozen_string_literal: true

require "bundler/setup"
require "another_grape_cache"
require "pry"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class FakeCacheBackend
  def read(_key)
    "foobar"
  end

  def write(_key, _value, **_options)
    "bar"
  end
end

AnotherGrapeCache.configure do |config|
  config.cache_backend = FakeCacheBackend.new
end
