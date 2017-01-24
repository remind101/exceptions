require 'honeybadger'

module Exceptions
  module Backends
    # Public: The Honeybadger backend is a Backend implementation that sends the
    # exception to Honeybadger.
    class Honeybadger < Backend
      attr_reader :honeybadger

      def initialize(honeybadger = ::Honeybadger)
        @honeybadger = honeybadger
      end

      def notify(exception_or_opts, opts = {})
        if id = honeybadger.notify(exception_or_opts, opts)
          Result.new(id)
        else
          BadResult.new
        end
      end

      def context(ctx)
        honeybadger.context(ctx)
      end

      def clear_context
        honeybadger.context.clear!
      end

      class Result < ::Exceptions::Result
        def url
          "https://www.honeybadger.io/notice/#{id}"
        end
      end
    end
  end
end
