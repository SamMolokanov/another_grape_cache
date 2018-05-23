# frozen_string_literal: true

require "grape"
require "another_grape_cache/version"
require "another_grape_cache/middlewares/miss_cache_middleware"
require "another_grape_cache/middlewares/hit_cache_middleware"
require "another_grape_cache/handlers/ignore_handler"
require "another_grape_cache/handlers/miss_handler"
require "another_grape_cache/dsl"
require "another_grape_cache/cache_helper"

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
    attr_accessor :cache_backend, :perform_caching

    def initialize
      @cache_backend = defined?(Rails) && Rails.cache
      @perform_caching = defined?(Rails) ? Rails.application.config.action_controller.perform_caching : true
    end
  end
end
