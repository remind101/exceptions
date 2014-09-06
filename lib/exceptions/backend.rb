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
    # Returns nil or a Result object.
    def notify(exception)
      raise NotImplementedError
    end
  end
end
