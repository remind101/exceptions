module Exceptions
  module Backends
    # Public: Test is an implementation of the Backend interface that accumulates exceptions.
    class Test < Backend
      attr_reader :reported_exceptions

      def initialize
        @reported_exceptions = []
      end

      def notify(exception, options = {})
        @reported_exceptions << exception
        Result.new(@reported_exceptions.count - 1)
      end
    end
  end
end

