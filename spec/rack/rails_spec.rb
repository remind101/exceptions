require 'spec_helper'

require 'logger'
require 'rack/test'
require 'rails'
require 'action_controller/railtie'
require 'action_dispatch/middleware/show_exceptions'

describe Rack::Exceptions, backend: :test do
  include Rack::Test::Methods

  class CustomError < StandardError; end

  class BoomsController < ActionController::Base
    def show
      raise CustomError, 'what the fun'
    end
  end

  class RailsApp < Rails::Application
    config.secret_key_base = 'not so secret after all, is it?'
    config.middleware.use Rack::Exceptions
    config.middleware.use ActionDispatch::ShowExceptions, proc { |env| [500, {}, "oops"] }

    routes.draw do
      get '/boom', to: 'booms#show'
    end
  end

  Rails.logger = Logger.new(STDERR)
  Rails.backtrace_cleaner.remove_filters!

  def app
    RailsApp
  end

  it 'tracks the error when an exception is raised' do
    get('/boom')
    expect(backend.reported_exceptions).to include(an_instance_of(CustomError))
  end
end
