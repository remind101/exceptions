module Exceptions
  # Public: Result represents a result of an Exception notification. It can be used
  # to return information about the exception.
  class Result
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def ok?
      true
    end
  end

  # Public: BadResult can be returned when there's a failure.
  class BadResult
    def ok?
      false
    end
  end
end
