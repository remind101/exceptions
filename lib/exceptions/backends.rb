module Exceptions
  module Backends
    autoload :Null,        'exceptions/backends/null'
    autoload :Raiser,      'exceptions/backends/raiser'
    autoload :Multi,       'exceptions/backends/multi'
    autoload :Logger,      'exceptions/backends/logger'
    autoload :Honeybadger, 'exceptions/backends/honeybadger'
  end
end
