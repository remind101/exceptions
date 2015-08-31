module Exceptions
  module Backends
    # Public: Context is a middleware that will add the given context options
    # whenever an exception is reported.
    class Context < Backend
      attr_reader :backend, :extra

      def initialize(backend, context = {})
        @backend = backend
        @extra = context
      end

      def notify(exception, *args)
        backend.context extra
        backend.notify(exception, *args)
      end

      def context(*args)
        backend.context(*args)
      end

      def clear_context(*args)
        backend.clear_context(*args)
      end
    end
  end
end
