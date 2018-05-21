# frozen_string_literal: true

module AnotherGrapeCache
  module Middlewares
    class HitCacheMiddleware < Grape::Middleware::Base
      def call!(env)
        cached_response(catch(:hit_cache) { return super })
      end

      def cached_response(_whatever)
        key = env["grape.another-cache.key"]
        cached_body = AnotherGrapeCache.configuration.cache_backend.read(key)

        header("X-Cache-Status", "HIT")
        header(Rack::CONTENT_TYPE, content_type)

        Rack::Response.new([cached_body], 200, headers)
      end
    end
  end
end
