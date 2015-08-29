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

      response
    ensure
      backend.clear_context
    end

    private

    def backend
      @backend ||= ::Exceptions.configuration.backend
    end
  end
end
