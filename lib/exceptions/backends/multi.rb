module Exceptions
  module Backends
    # Public: Multi is an implementation of the Backend interface for wrapping multiple
    # backends as a single Backend.
    class Multi < Backend
      attr_reader :backends

      def initialize(*backends)
        @backends = backends
      end

      def notify(exception, options = {})
        backends.each do |backend|
          backend.notify exception, options
        end
      end
    end
  end
end
