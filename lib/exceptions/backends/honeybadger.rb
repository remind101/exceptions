require 'honeybadger'

module Exceptions
  module Backends
    # Public: The Honeybadger backend is a Backend implementation that sends the 
    # exception to Honeybadger.
    class Honeybadger < Backend
      def notify(exception, options = {})
        ::Honeybadger.notify_or_ignore(exception, options)
      end
    end
  end
end
