require 'spec_helper'

describe Exceptions::Backends::Honeybadger do
  let(:honeybadger) { double(::Honeybadger) }

  let(:backend) do
    described_class.new honeybadger
  end

  describe '#notify' do
    subject(:result) { backend.notify(boom) }

    context 'when successful' do
      before do
        expect(honeybadger).to receive(:notify_or_ignore).and_return('1234')
      end

      it 'returns the result' do
        expect(result.id).to eq '1234'
      end
    end

    context 'when errored' do
      before do
        expect(honeybadger).to receive(:notify_or_ignore).and_return(nil)
      end

      it 'returns the result' do
        expect(result.id).to eq nil
      end
    end
  end
end
