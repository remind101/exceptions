require 'honeybadger'

module Exceptions
  module Backends
    # Public: The Honeybadger backend is a Backend implementation that sends the 
    # exception to Honeybadger.
    class Honeybadger < Backend
      def notify(exception)
        ::Honeybadger.notify_or_ignore(exception)
      end
    end
  end
end
