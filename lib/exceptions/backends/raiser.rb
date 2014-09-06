module Exceptions
  module Backends
    # Public: Raiser is an implementation of the Backend interface that raises the exception.
    class Raiser < Backend
      def notify(exception, options = {})
        raise exception
      end
    end
  end
end
