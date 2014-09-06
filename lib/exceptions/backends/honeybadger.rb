require 'honeybadger'

module Exceptions
  module Backends
    # Public: The Honeybadger backend is a Backend implementation that sends the 
    # exception to Honeybadger.
    class Honeybadger < Backend
      def notify(exception, options = {})
        if id = ::Honeybadger.notify_or_ignore(exception, options)
          Result.new id
        else
          BadResult.new
        end
      end
    end
  end
end
