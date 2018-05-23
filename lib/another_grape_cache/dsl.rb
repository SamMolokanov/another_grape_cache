# frozen_string_literal: true

module AnotherGrapeCache
  module DSL
    extend ActiveSupport::Concern

    module ClassMethods
      def cache(expires_in:, max_age: nil, private_cache: true, &block)
        return unless AnotherGrapeCache.configuration.perform_caching

        namespace_inheritable(:another_cache, cache_key: block)

        cache_handlers = {
          "MISS" => Handlers::MissHandler.new(expires_in: expires_in, max_age: max_age, private_cache: private_cache),
          "IGNORE" => Handlers::IgnoreHandler.new,
        }

        use Middlewares::MissCacheMiddleware, cache_handlers: cache_handlers
        use Middlewares::HitCacheMiddleware, namespace_inheritable(:another_cache)
      end
    end
  end
end
