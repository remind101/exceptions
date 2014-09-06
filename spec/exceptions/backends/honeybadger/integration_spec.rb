require 'spec_helper'

describe Exceptions::Backends::Honeybadger, backend: :honeybadger do
  describe '#notify' do
    it 'sends the exception to honeybadger' do
      Exceptions.context(request_id: '1234')
      result = Exceptions.notify(boom)
      expect(result.id).to_not be_empty
    end
  end
end
