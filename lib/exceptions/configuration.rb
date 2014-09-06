module Exceptions
  class Configuration
    # The exception tracking backend to use.
    attr_accessor :backend

    def backend
      @backend ||= Backends::Honeybadger
    end
  end
end
