module Loggers
  class ClientLogger < ::AppLogger
    def self.init(name = :clients)
      super(name)
    end
  end
end
