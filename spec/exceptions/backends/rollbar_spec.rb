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

    it "reports exceptions to the rollbar reporter untouched" do
      expect(rollbar).to receive(:log)
        .with("error", boom, nil,
              Exceptions::Backends::Rollbar::DEFAULT_NOTIFY_ARGS)
      subject
    end

    it "converts strings into fake exceptions for the reporter" do
      expect(rollbar).to receive(:log) do |_, exception, *|
        expect(exception.class.name).to eq("ErrorName")
        expect(exception.message).to eq("The message")
      end
      backend.notify(error_class: "ErrorName", error_message: "The message")
    end

    it "doesn't choke if reporting with objects of the wrong type" do
      expect(rollbar).to receive(:log) do |_, exception, *|
        expect(exception.class.name).to match(/#<Object:\w+>/)
        expect(exception.message).to match(/#<Object:\w+>/)
      end
      backend.notify(Object.new, error_message: Object.new)
    end
  end

  describe "integration with Rack::Exceptions" do
    let(:app) { double(:app, call: response) }
    let(:response) { [200, {}, []] }
    let(:wrapped) { Rack::Exceptions.new(app, backend) }
    let(:env) { Rack::MockRequest.env_for("https://example.org/") }
    let(:request_data) do
      {url: "https://example.org", params: {}, GET: {}, POST: {}, body: "{}",
       user_ip: "", headers: {"Content-Length" => "0"}, cookies: {},
       session: {}, method: "GET"}
    end

    before do
      allow(rollbar).to receive(:reset_notifier!)
      allow(rollbar).to receive(:scoped).and_yield
    end

    it "passes along request data when there's an exception" do
      allow(app).to receive(:call).and_raise(boom)
      expect(rollbar).to receive(:log)
        .with("error", boom, nil, use_exception_level_filters: true)
      expect { wrapped.call(env) }.to raise_error(boom)
      expect(rollbar).to have_received(:scoped).with(request: request_data)

      # and it clears the rack env after the request ends
      expect(Rack::Exceptions.rack_env).to be_nil
    end

    it "passes along request data when calling the notifier manually" do
      allow(app).to receive(:call) do
        backend.notify("MyError")
        response
      end
      expect(rollbar).to receive(:log) do |level, error, description, extra|
        expect(level).to eq("error")
        expect(error.class.name).to eq("MyError")
        expect(description).to be_nil
        expect(extra).to eq(use_exception_level_filters: true)
      end
      wrapped.call(env)
      expect(rollbar).to have_received(:scoped).with(request: request_data)
    end

    it "passes along the error_class and error_message params" do
      allow(app).to receive(:call) do
        backend.notify(error_class: "MyError", error_message: "The message")
        response
      end
      expect(rollbar).to receive(:log) do |level, error, description, extra|
        expect(level).to eq("error")
        expect(error.class.name).to eq("MyError")
        expect(description).to eq("The message")
        expect(extra).to eq(use_exception_level_filters: true)
      end
      wrapped.call(env)
      expect(rollbar).to have_received(:scoped).with(request: request_data)
    end
  end
end
