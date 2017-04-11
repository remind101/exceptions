module Rack
  class Exceptions
    def initialize(app, backend = nil)
      @app     = app
      @backend = backend
    end

    def call(env)
      begin
        response = @app.call(env)
      rescue Exception => e
        backend.notify(e, rack_env: env)
        raise
      end

      framework_exception = framework_exception(env)
      if framework_exception
        backend.notify(framework_exception, rack_env: env)
      end

      response
    ensure
      backend.clear_context
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
