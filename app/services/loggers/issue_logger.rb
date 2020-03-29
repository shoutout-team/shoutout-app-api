module Loggers
  class IssueLogger < ::AppLogger
    def self.init(name = :issues)
      super(name)
    end
  end
end
