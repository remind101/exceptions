require 'spec_helper'

describe Exceptions::Backends::Rollbar do
  let(:rollbar) { double(::Rollbar) }

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
end

