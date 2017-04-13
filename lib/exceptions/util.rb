module Exceptions
  class Util
    def self.deep_dup(obj)
      Marshal.load(Marshal.dump(obj))
    end
  end
end
