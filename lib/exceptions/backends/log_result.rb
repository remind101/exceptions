require 'logger'

module Exceptions
  module Backends
    # Public: LogResult is an implementation of the Backend interface the wraps an existing backend and logs
    # the result id and url.
    class LogResult < Backend
      attr_reader :backend, :logger

      def initialize(backend, logger = ::Logger.new(STDOUT))
        @backend = backend
        @logger  = logger
      end

      def notify(exception, options = {})
        backend.notify(exception, options).tap do |result|
          log exception, result
        end
      end

      def rack_exception(exception, env)
        backend.rack_exception(exception, env).tap do |result|
          log exception, result
        end
      end

      def context(*args)
        backend.context(*args)
      end

      def clear_context(*args)
        backend.clear_context(*args)
      end

      private

      def log(exception, result)
        logger.info "at=exception exception=#{exception.class} message=\"#{exception}\" " + \
          "exception-id=#{result.id} url=#{result.url} source=#{source} count#exception=1" if result.ok?
      end

      def source
        ''
      end
    end
  end
end
