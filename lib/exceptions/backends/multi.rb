require 'exceptions/util'

module Exceptions
  module Backends
    # Public: Multi is an implementation of the Backend interface for wrapping multiple
    # backends as a single Backend.
    class Multi < Backend
      attr_reader :backends

      def initialize(*backends)
        @backends = backends
      end

      def notify(*args)
        results = backends.map { |be| be.notify(*Util.deep_dup(args)) }
        MultiResult.new results.map(&:id), results.map(&:url)
      end

      def context(*args)
        backends.each { |backend| backend.context(*args) }
      end

      def clear_context(*args)
        backends.each { |backend| backend.clear_context(*args) }
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
