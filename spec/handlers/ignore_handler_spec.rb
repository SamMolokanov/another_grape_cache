# frozen_string_literal: true

RSpec.describe AnotherGrapeCache::Handlers::IgnoreHandler do
  describe "#handle" do
    let(:response) { double "Response", set_header: true }
    let(:env) { {} }

    before { described_class.new.handle(response, env) }

    it "sets cache status IGNORED header on response" do
      expect(response).to have_received(:set_header).with("X-Cache-Status", "IGNORED")
    end
  end
end
