require 'honeybadger'

Honeybadger.configure do |config|
  config.api_key = ENV.fetch('HONEYBADGER_API_KEY')
  config.environment_name = 'testing'
end
