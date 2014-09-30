require 'spec_helper'

describe Exceptions::Backends::LogResult do
  let(:logger) { double(::Logger) }
  let(:backend) do
    described_class.new \
      double(Exceptions::Backend, notify: double(Exceptions::Result, ok?: true, id: '1234', url: 'http://exception.com')),
      logger
  end

  describe '#notify' do
    subject(:result) { backend.notify(boom) }

    it 'logs the result' do
      expect(logger).to receive(:info).with("at=exception exception=StandardError message=\"Boom\" exception-id=1234 url=http://exception.com source= count#exception=1")
      result
    end
  end
end
