# frozen_string_literal: true

require "grape"
require "another_grape_cache/version"
require "another_grape_cache/middlewares/hit_cache_middleware"

module AnotherGrapeCache
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration) if block_given?

    raise "Please provide cache_backend configuration" unless configuration.cache_backend
  end

  class Configuration
    attr_accessor :cache_backend

    def initialize
      @cache_backend = defined?(Rails) && Rails.cache
    end
  end
end
