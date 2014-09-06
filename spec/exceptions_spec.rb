require 'spec_helper'

describe Exceptions do
  describe '.notify' do
    it 'delegates to the backend' do
      expect(backend).to receive(:notify)
      Exceptions.notify(boom)
    end
  end
end
