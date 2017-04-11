require 'spec_helper'

describe Rack::Exceptions do
  let(:response) { [200, {}, []] }
  let(:app) { double('app', call: response) }
  let(:middleware) { described_class.new app }

  describe '#call' do
    context 'when no exception is raised' do
      it 'returns the response' do
        expect(middleware.call({})).to eq response
      end
    end

    context 'when an exception is raised' do
      before do
        expect(app).to receive(:call).and_raise(boom)
      end

      it 'tracks the error' do
        expect { middleware.call({}) }.to raise_error
      end
    end
  end
end
