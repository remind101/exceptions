require 'spec_helper'

describe Exceptions::Backends::Rollbar do
  let(:rollbar) { double(::Rollbar) }

  before { allow(rollbar).to receive(:scoped).and_yield }

  let(:backend) do
    described_class.new rollbar
  end

  describe '#notify' do
    subject(:result) { backend.notify(boom) }

    context 'when successful' do
      before do
        expect(rollbar).to receive(:log).and_return(uuid: 'error-uuid')
      end

      it 'returns the result' do
        expect(result.id).to eq 'error-uuid'
      end
    end

    context 'when errored' do
      before do
        expect(rollbar).to receive(:log).and_return('error')
      end

      it 'returns the result' do
        expect(result.id).to eq nil
      end
    end
  end

  describe "integration with Rack::Exceptions" do
    let(:app) { double(:app, call: [200, {}, []]) }
    let(:wrapped) { Rack::Exceptions.new(app, backend) }
    before do
      allow(rollbar).to receive(:reset_notifier!)
      allow(rollbar).to receive(:scoped).and_yield
    end

    it "passes along request data when there's an exception" do
      allow(app).to receive(:call).and_raise(boom)
      expect(rollbar).to receive(:log)
        .with("error", boom, nil, use_exception_level_filters: true)
      expect do
        wrapped.call(Rack::MockRequest.env_for("https://example.org/"))
      end.to raise_error(boom)

      request = {url: "https://example.org", params: {}, GET: {}, POST: {},
                 body: "{}", user_ip: "", headers: {"Content-Length" => "0"},
                 cookies: {}, session: {}, method: "GET"}
      expect(rollbar).to have_received(:scoped).with(request: request)
    end
  end
end
