# frozen_string_literal: true

module AnotherGrapeCache
  module CacheHelper
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength
    included do
      include DSL

      after_validation do
        if AnotherGrapeCache.configuration.perform_caching && (request.get? || request.head?)
          options = namespace_inheritable(:another_cache)

          endpoint_context = env[Grape::Env::API_ENDPOINT]
          cache_if_proc = options[:cache_if]
          need_perform_cache = endpoint_context.instance_exec(&cache_if_proc)

          if need_perform_cache
            cache_key_proc = options[:cache_key]
            cache_key = endpoint_context.instance_exec(&cache_key_proc)

            format = env[Grape::Env::API_FORMAT]
            uri_hash = Digest::MD5.hexdigest(env["REQUEST_PATH"])

            env["grape.another-cache.key"] = "another-cache/#{format}/#{uri_hash}/#{cache_key}"

            if AnotherGrapeCache.configuration.cache_backend.exist?(env["grape.another-cache.key"])
              env["grape.another-cache.status"] = "HIT"
              throw(:hit_cache)
            else
              env["grape.another-cache.status"] = "MISS"
            end
          else
            env["grape.another-cache.status"] = "IGNORED"
          end
        else
          env["grape.another-cache.status"] = "IGNORED"
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
