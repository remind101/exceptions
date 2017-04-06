require 'rollbar'

module Exceptions
  module Backends
    # Public: The Rollbar backend is a Backend implementation that sends the
    # exception to Rollbar.
    class Rollbar
      DEFAULT_NOTIFY_ARGS = {
        # without this, rollbar won't ignore the error classes defined in
        # config/initializers/exceptions.rb
        use_exception_level_filters: true
      }

      attr_reader :rollbar

      def initialize(rollbar = ::Rollbar)
        @rollbar = rollbar
      end

      def notify(exception = nil, level: 'error', error_class: nil, error_message: nil, parameters: {}, context: {})
        err = exception || error_class
        extra = [DEFAULT_NOTIFY_ARGS, parameters, context].reduce(&:merge)
        Response.wrap(rollbar.log(level, err, error_message, extra))
      end

      def context(ctx)
        # rollbar does special tracking of the `person` key, but `user` is a more
        # common name for this.
        ctx = Marshal.load(Marshal.dump(ctx)) # deep clone
        ctx[:person] = ctx.delete(:user) if ctx.key?(:user)
        rollbar.scope!(ctx)
      end

      def clear_context
        rollbar.reset_notifier!
      end

      class Response < Struct.new(:id)
        def self.wrap(rollbar_result)
          return new(nil) if String === rollbar_result
          new(rollbar_result[:uuid])
        end

        def url
          "https://rollbar.com/instance/uuid?uuid=#{id}"
        end
      end
    end
  end
end
