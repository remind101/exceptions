require 'spec_helper'

describe Exceptions::Backends::Honeybadger, backend: :honeybadger do
  before do
    Exceptions.clear_context
  end

  describe '#notify' do
    it 'sends the exception to honeybadger' do
      Exceptions.context(request_id: '1234')
      result = Exceptions.notify(boom)
      expect(result.id).to_not be_empty
      expect(result.url).to_not be_empty
    end
  end

  describe '#context' do
    it 'sets the honeybadger context' do
      expect {
        Exceptions.context(request_id: '1234')
      }.to change { Thread.current[:honeybadger_context] }.from(nil).to(request_id: '1234')
    end
  end
end
