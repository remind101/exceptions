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
end
