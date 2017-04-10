require 'rollbar'
require 'rollbar/request_data_extractor'

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

      def notify(exception = nil, level: 'error', error_class: nil,
                 rack_env: {}, error_message: nil, parameters: {}, context: {})
        err = exception || error_class
        extra = [DEFAULT_NOTIFY_ARGS, parameters, context].reduce(&:merge)
        rollbar.scoped(rollbar_scope(rack_env)) do
          Response.wrap(rollbar.log(level, err, error_message, extra))
        end
      end

      def context(ctx)
        ctx = ctx.dup

        # rollbar does special tracking of the `person` key, but `user` is a more
        # common name for this.
        ctx[:person] = ctx.delete(:user) if ctx.key?(:user)
        rollbar.scope!(ctx)
      end

      def clear_context
        rollbar.reset_notifier!
      end

      class Response < Struct.new(:id)
        def self.wrap(rollbar_result)
          # XXX: why would rollbar_result be a string?????
          return new(nil) if String === rollbar_result
          new(rollbar_result[:uuid])
        end

        def url
          "https://rollbar.com/instance/uuid?uuid=#{id}"
        end
      end

      private

      def rollbar_scope(env)
        if env.present?
          {request: RollbarExtractor.extract_request_data_from_rack(env)}
        else
          {}
        end
      end

      RollbarExtractor = Object.new.extend(::Rollbar::RequestDataExtractor)
    end
  end
end
