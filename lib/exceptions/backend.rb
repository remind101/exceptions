module Exceptions
  # Public: Backend is an abstract class that documents the interface
  # for an exception tracking backend.
  class Backend
    # Public: Notify should be implemented by classes that inherit from Backend to
    # do something with the exception. Implementers of this interface can optionally
    # return a Result object which can include things like an exception id from
    # an external service.
    #
    # exception - An Exception object.
    # options   - A Hash of options.
    #
    # Returns an object satisfying the Result interface.
    def notify(exception)
      raise NotImplementedError
    end

    # Public: Context can be used to set global context.
    #
    # ctx - A Hash of contextual information.
    #
    # Returns nothing.
    def context(ctx)
    end

    # Public: Clear should clear the context.
    #
    # Returns nothing.
    def clear_context
    end

    # Public: Called by the Rack middleware when an exception is raised.
    #
    # Returns and object satisfying the Result interface.
    def rack_exception(exception, env)
      notify(exception)
    end
  end
end
