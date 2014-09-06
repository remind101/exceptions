module Exceptions
  module Backends
    autoload :Null,        'exceptions/backends/null'
    autoload :Honeybadger, 'exceptions/backends/honeybadger'
  end
end
