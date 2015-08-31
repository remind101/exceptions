require 'spec_helper'

describe Exceptions::Backends::Context do
  let(:backend) { double(Exceptions::Backend) }
  let(:middleware) do
    described_class.new backend, foo: 'bar'
  end

  describe '#notify' do
    it 'sets the context' do
      expect(backend).to receive(:context).with(foo: 'bar')
      expect(backend).to receive(:notify).with(boom)
      middleware.notify(boom)
    end
  end
end
