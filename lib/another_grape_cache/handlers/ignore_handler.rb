# frozen_string_literal: true

module AnotherGrapeCache
  module Handlers
    class IgnoreHandler
      def handle(response, _env)
        response.set_header("X-Cache-Status", "IGNORED")
        response
      end
    end
  end
end
