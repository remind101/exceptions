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

      def notify(exception, options = {})
        backtrace = caller
        defaults = { backtrace: backtrace.last(backtrace.length - 1) }
        if id = honeybadger.notify_or_ignore(exception, defaults.merge(options))
          Result.new id
        else
          BadResult.new
        end
      end

      def context(ctx)
        honeybadger.context ctx
      end

      def clear_context
        honeybadger.clear!
      end

      def rack_exception(exception, env)
        notify(exception, rack_env: env) unless honeybadger.
          configuration.
          ignore_user_agent.
          flatten.
          any? { |ua| ua === env['HTTP_USER_AGENT'] }
      end

      class Result < ::Exceptions::Result
        def url
          "https://www.honeybadger.io/notice/#{id}"
        end
      end
    end
  end
end
