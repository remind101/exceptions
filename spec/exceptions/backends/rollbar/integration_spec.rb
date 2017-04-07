require 'spec_helper'

describe Exceptions::Backends::Rollbar, backend: :rollbar do
  before do
    Exceptions.clear_context
  end

  describe '#notify' do
    it 'sends the exception to rollbar' do
      Exceptions.context(request_id: '1234')
      result = Exceptions.notify(boom)
      expect(result.id).to_not be_empty
      expect(result.url).to_not be_empty
    end
  end

  describe '#context' do
    it 'sets the rollbar scope' do
      expect {
        Exceptions.context(request_id: '1234')
      }.to change { Rollbar.notifier.scope_object[:request_id] }.from(nil).to('1234')
    end
  end
end

