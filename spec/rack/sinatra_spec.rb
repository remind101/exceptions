require 'spec_helper'

require 'rack/test'
require 'sinatra/base'

describe Rack::Exceptions, backend: :test do
  include Rack::Test::Methods

  class CustomError < StandardError; end

  class SinatraApp < Sinatra::Base
    set :show_exceptions, false # production

    use Rack::Exceptions

    get '/boom' do
      raise CustomError, 'what the fun'
    end
  end

  def app
    SinatraApp.new
  end

  it 'tracks the error when an exception is raised' do
    get('/boom')
    expect(backend.reported_exceptions).to include(an_instance_of(CustomError))
  end

  it 'populates request data into rollbar' do
    rollbar_client = double(:rollbar_client, reset_notifier!: ->{},
                            log: ->(*){})
    allow(rollbar_client).to receive(:scoped).and_yield
    with_backend(Exceptions::Backends::Rollbar.new(rollbar_client)) do
      get('/boom')
    end
    request = {url: "http://example.org", params: {}, GET: {}, POST: {},
               body: "{}", user_ip: "127.0.0.1", cookies: {}, session: {},
               headers: {"Content-Length" => "0", "Host" => "example.org"},
               method: "GET"}
    expect(rollbar_client).to have_received(:scoped)
      .with({request: request})
  end
end
