require 'spec_helper'

describe Exceptions::Backends::Multi do
  let(:backend) do
    described_class.new \
      double(Exceptions::Backend, notify: double(Exceptions::Result, id: 1, url: 'http://www.foo.bar')),
      double(Exceptions::Backend, notify: double(Exceptions::Result, id: 2, url: 'http://www.bar.foo'))
  end

  describe '#notify' do
    describe 'result' do
      subject(:result) { backend.notify(boom) }

      specify { expect(result.id).to eq '1,2' }
      specify { expect(result.url).to eq 'http://www.foo.bar,http://www.bar.foo' }
    end
  end
end
