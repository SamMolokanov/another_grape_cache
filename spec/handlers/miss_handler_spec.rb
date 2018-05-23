# frozen_string_literal: true

RSpec.describe AnotherGrapeCache::Handlers::MissHandler do
  describe "#handle" do
    context "when response is successful" do
      let(:response) { double "Response", set_header: true, body: ["foobar"], status: 200 }
      let(:env) { {} }

      before { described_class.new(private_cache: true).handle(response, env) }

      it "sets cache status MISS header on response" do
        expect(response).to have_received(:set_header).with("X-Cache-Status", "MISS")
      end

      it "sets Cache-Control header based on options" do
        expect(response).to have_received(:set_header).with("Cache-Control", "max-age=0, must-revalidate, private")
      end
    end

    context "when response is not successful" do
      let(:response) { double "Response", set_header: true, status: 404 }
      let(:env) { {} }

      before { described_class.new.handle(response, env) }

      it "does not set headeres on response" do
        expect(response).not_to have_received(:set_header)
      end
    end
  end
end
