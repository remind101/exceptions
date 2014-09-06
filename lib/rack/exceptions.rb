module Rack
  class Exceptions
    attr_reader :backend

    def initialize(app, backend = nil)
      @app     = app
      @backend = backend || ::Exceptions.configuration.backend
    end

    def call(env)
      begin
        response = @app.call(env)
      rescue Exception => e
        backend.rack_exception(e, env)
        raise
      end

      response
    ensure
      backend.clear_context
    end
  end
end
