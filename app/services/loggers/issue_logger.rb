module Loggers
  class IssueLogger < ::AppLogger
    def self.init(name = :issue)
      super(name)
    end
  end
end
