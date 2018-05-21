# frozen_string_literal: true

RSpec.describe AnotherGrapeCache::Middlewares::HitCacheMiddleware do
  describe "don't throwing :hit_cache" do
    let(:app) { double "Endpoint" }
    let(:env) { {} }

    before { allow(app).to receive(:call) { "foobar" } }

    subject(:response) { described_class.new(app, {}).call!(env) }

    it "returns apps response" do
      expect(response).to eq "foobar"
    end
  end

  describe "throwing :hit_cache" do
    let(:fake_cache) { double "CacheBackend", read: "foo" }

    before do
      AnotherGrapeCache.configure do |config|
        config.cache_backend = fake_cache
      end
    end

    context "when adds X-Cache-Status header" do
      let(:app) { double "Endpoint" }
      let(:env) { {} }

      before { allow(app).to receive(:call) { |_whatever| throw(:hit_cache) } }

      subject(:cache_status) { described_class.new(app, {}).call!(env)["X-Cache-Status"] }

      it "sets header X-Cache-Status as HIT" do
        expect(cache_status).to eq "HIT"
      end
    end

    context "when responds with requested api format" do
      context "when default value" do
        let(:app) { double "Endpoint" }
        let(:env) { {} }

        before { allow(app).to receive(:call) { |_whatever| throw(:hit_cache) } }

        subject(:content_type) { described_class.new(app).call!(env)["Content-Type"] }

        it "sets Content-Type to default text" do
          expect(content_type).to eq "text/html"
        end
      end

      context "when json format" do
        let(:app) { double "Endpoint" }
        let(:env) { { "api.format" => :json } }

        before { allow(app).to receive(:call) { |_whatever| throw(:hit_cache) } }

        subject(:content_type) { described_class.new(app).call!(env)["Content-Type"] }

        it "sets Content-Type application/json" do
          expect(content_type).to eq "application/json"
        end
      end
    end

    context "when reads from cache" do
      let(:app) { double "Endpoint" }
      let(:env) { { "grape.another-cache.key" => "fake_cache_key" } }

      before do
        allow(app).to receive(:call) { |_whatever| throw(:hit_cache) }
        described_class.new(app).call!(env)
      end

      it "reads from cache backend with key" do
        expect(fake_cache).to have_received(:read).with("fake_cache_key")
      end
    end

    context "when builds body" do
      let(:app) { double "Endpoint" }
      let(:env) { {} }

      before { allow(app).to receive(:call) { |_whatever| throw(:hit_cache) } }

      subject(:body) { described_class.new(app).call!(env).body }

      it "returns cached value as single part" do
        expect(body).to eq ["foo"]
      end
    end
  end
end
