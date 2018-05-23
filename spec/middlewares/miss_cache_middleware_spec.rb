# frozen_string_literal: true

RSpec.describe AnotherGrapeCache::Middlewares::MissCacheMiddleware do
  describe "#after" do
    context "when handler is set for a cache status" do
      let(:app) { double "Endpoint", call: true }
      let(:handler) { double "CacheHandler", handle: "foo" }

      let(:options) do
        { cache_handlers: { "MISS" => handler } }
      end

      let(:env) { { "grape.another-cache.status" => "MISS" } }
      let(:middleware) { described_class.new(app, options) }

      before { allow(middleware).to receive(:response).and_return("bar") }

      subject(:result) { middleware.call!(env) }

      it "delegates response handling to handler with env" do
        subject
        expect(handler).to have_received(:handle).with("bar", "grape.another-cache.status" => "MISS")
      end

      it "returns result from the handler call" do
        expect(result).to eq "foo"
      end
    end

    context "when handler is not set for a cache status" do
      let(:app) { double "Endpoint", call: [200, {}, ["foobar"]] }
      let(:handler) { double "CacheHandler", handle: "foo" }

      let(:options) do
        { cache_handlers: { "FOO" => handler } }
      end

      let(:env) { { "grape.another-cache.status" => "MISS" } }
      let(:middleware) { described_class.new(app, options) }

      before { allow(middleware).to receive(:response).and_return("bar") }

      subject(:result) { middleware.call!(env) }

      it "returns standard response of middleware" do
        expect(subject).to eq "bar"
      end
    end
  end
end
