module Exceptions
  module Backends
    # Public: Null is an implementation of the Backend interface that does nothing.
    class Null < Backend
      def notify(exception, options = {}); end
    end
  end
end
