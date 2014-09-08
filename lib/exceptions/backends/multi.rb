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
        results = backends.map do |backend|
          backend.notify exception, options
        end

        MultiResult.new results.map(&:id), results.map(&:url)
      end

      class MultiResult < ::Exceptions::Result
        def initialize(ids, urls)
          @id  = ids.join(',')
          @url = urls.join(',')
        end
      end
    end
  end
end
