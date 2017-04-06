require 'spec_helper'

describe Exceptions::Backends::Multi do
  let(:backend1) { double(Exceptions::Backend, notify: double(Exceptions::Result, id: 1, url: 'http://www.foo.bar')) }
  let(:backend2) { double(Exceptions::Backend, notify: double(Exceptions::Result, id: 2, url: 'http://www.bar.foo')) }
  let(:multi_backend) { described_class.new(backend1, backend2) }

  describe '#notify' do
    describe 'result' do
      subject(:result) { multi_backend.notify(boom) }

      specify { expect(result.id).to eq '1,2' }
      specify { expect(result.url).to eq 'http://www.foo.bar,http://www.bar.foo' }
    end
  end

  specify '#context sets the context on every backend' do
    expect(backend1).to receive(:context).with(request_id: '1234')
    expect(backend2).to receive(:context).with(request_id: '1234')
    multi_backend.context(request_id: '1234')
  end

  specify '#clear_context clears the context on every backend' do
    expect(backend1).to receive(:clear_context)
    expect(backend2).to receive(:clear_context)
    multi_backend.clear_context
  end
end
