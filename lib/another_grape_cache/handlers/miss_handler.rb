# frozen_string_literal: true

module AnotherGrapeCache
  module Handlers
    class MissHandler
      def initialize(**options)
        @options = options
      end

      def handle(response, env)
        @response = response
        @env = env
        return @response unless response_successful?

        write_cache
        add_cache_headers

        @response
      end

      private

      def write_cache
        AnotherGrapeCache.configuration.cache_backend.write(
          @env["grape.another-cache.key"],
          @response.body.join,
          compress: true,
          expires_in: @options[:expires_in],
        )
      end

      def add_cache_headers
        @response.set_header("X-Cache-Status", "MISS")

        @response.set_header(
          Rack::CACHE_CONTROL,
          [
            "max-age=#{@options[:max_age] ? @options[:max_age].from_now.to_i : '0, must-revalidate'}",
            @options[:private_cache] ? "private" : "public",
          ].join(", "),
        )
      end

      def response_successful?
        @response.status == 200
      end
    end
  end
end
