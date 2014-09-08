module Exceptions
  module Backends
    # Public: Logger is an implementation of the Backend interface that logs exceptions
    # to STDOUT.
    class Logger < Backend
      attr_accessor :logger

      def initialize(logger = ::Logger.new(STDOUT))
        @logger = logger
      end

      def notify(exception, options = {})
        logger.info exception
        Result.new
      end
    end
  end
end
