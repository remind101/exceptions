require 'spec_helper'

describe Exceptions::Backends::Logger, backend: :logger do
  describe '.notify' do
    it 'logs the exception to stdout' do
      Exceptions.notify(boom)
    end
  end
end
