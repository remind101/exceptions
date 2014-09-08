module Exceptions
  # Public: A Result represents the result of an exception notification. It's an object
  # that conforms to the following interface:
  #
  #   `id`  - The exception id from the third party service.
  #   `url` - A URL to view the exception in the third party service.
  #   `ok?` - True if the exception was successfully shuttled.
  #
  # This class is mostly a reference implementation but anything that conforms to the
  # above interface is acceptable to return.
  class Result
    attr_reader :id, :url

    def initialize(id = nil)
      @id = id
    end

    def url
      @url ||= ""
    end

    def ok?
      true
    end
  end

  # Public: BadResult can be returned when there's a failure.
  class BadResult < Result
    def ok?
      false
    end
  end
end
