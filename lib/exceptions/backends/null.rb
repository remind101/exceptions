module Exceptions
  module Backends
    # Public: Null is an implementation of the Backend interface that does nothing.
    class Null < Backend
      def notify(exception, options = {})
        Result.new
      end
    end
  end
end
