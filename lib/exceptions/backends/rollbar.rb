require 'rollbar'
require 'rollbar/request_data_extractor'

module Exceptions
  module Backends
    # Public: The Rollbar backend is a Backend implementation that sends the
    # exception to Rollbar.
    class Rollbar
      DEFAULT_NOTIFY_ARGS = {
        # without this, rollbar won't ignore the error classes defined in
        # `config.exception_level_filters`
        use_exception_level_filters: true
      }

      attr_reader :rollbar

      def initialize(rollbar = ::Rollbar)
        @rollbar = rollbar
      end

      def notify(exception = nil, level: 'error', error_class: nil,
                 rack_env: nil, error_message: nil, parameters: {}, context: {})
        err = maybe_turn_into_exception(exception || error_class, error_message)
        extra = [DEFAULT_NOTIFY_ARGS, parameters, context].reduce(&:merge)
        rollbar.scoped(rollbar_scope(rack_env)) do
          wrap_rollbar_result(rollbar.log(level, err, error_message, extra))
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

      private

      # if reporting via the `error_class` and `error_message` args, we need to
      # trick the rollbar reporter into thinking it's an actual exception. by
      # doing that, rollbar will report the error class and message correctly,
      # and show a stack trace, which it doesn't do when passing it a string.
      def maybe_turn_into_exception(error_class_or_exception_or_string,
                                    error_message)
        if error_class_or_exception_or_string.is_a?(Exception)
          error_class_or_exception_or_string
        else
          Class.new(StandardError) do
            define_singleton_method(:name) do
              error_class_or_exception_or_string.to_s
            end
            define_method(:message) { error_message.to_s }
          end.new
        end
      end

      def wrap_rollbar_result(rollbar_result)
        return BadResult.new if !rollbar_result.is_a?(Hash)
        id = rollbar_result[:uuid]
        Result.new(id, "https://rollbar.com/instance/uuid?uuid=#{id}")
      end

      def rollbar_scope(env)
        if env
          {request: RollbarExtractor.extract_request_data_from_rack(env)}
        else
          {}
        end
      end

      RollbarExtractor = Object.new.extend(::Rollbar::RequestDataExtractor)
    end
  end
end
