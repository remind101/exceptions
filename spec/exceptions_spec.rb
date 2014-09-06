require 'spec_helper'

describe Exceptions do
  describe '.notify' do
    it 'delegates to the backend' do
      expect(backend).to receive(:notify).and_call_original
      Exceptions.notify(boom)
    end
  end
end
