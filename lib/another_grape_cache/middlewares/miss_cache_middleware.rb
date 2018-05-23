# frozen_string_literal: true

module AnotherGrapeCache
  module Middlewares
    class MissCacheMiddleware < Grape::Middleware::Base
      def after
        return unless @app_response

        cache_status = env["grape.another-cache.status"]
        handler = options.dig(:cache_handlers, cache_status)
        handler ? handler.handle(response, env) : response
      end
    end
  end
end
