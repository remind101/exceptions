module Rack
  class Exceptions
    # XXX: applications are typically configured with a single global instance
    # of the exceptions reporter. use a thread local to store the current rack
    # so different threads don't see the same request info
    def self.rack_env
      Thread.current[:exception_rack_env]
    end

    def initialize(app, backend = nil)
      @app     = app
      @backend = backend
    end

    def call(env)
      Thread.current[:exception_rack_env] = env

      begin
        response = @app.call(env)
      rescue Exception => e
        backend.notify(e)
        raise
      end

      framework_exception = framework_exception(env)
      if framework_exception
        backend.notify(framework_exception)
      end

      response
    ensure
      backend.clear_context
      Thread.current[:exception_rack_env] = nil
    end

    private

    def backend
      @backend ||= ::Exceptions.configuration.backend
    end

    def framework_exception(env)
      env['action_dispatch.exception'] || env['rack.exception'] || env['sinatra.error']
    end
  end
end
