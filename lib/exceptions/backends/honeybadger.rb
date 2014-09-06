require 'honeybadger'

module Exceptions
  module Backends
    # Public: The Honeybadger backend is a Backend implementation that sends the 
    # exception to Honeybadger.
    class Honeybadger < Backend
      def notify(exception, options = {})
        if id = ::Honeybadger.notify_or_ignore(exception, options)
          Result.new id
        else
          BadResult.new
        end
      end

      def context(ctx)
        ::Honeybadger.context ctx
      end

      def clear_context
        ::Honeybadger.clear!
      end

      def rack_exception(exception, env)
        notify(exception, rack_env: env) unless ::Honeybadger.
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
