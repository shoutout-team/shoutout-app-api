module App
  module Hosting
    class EnvironmentUndefined < StandardError; end

    def self.production_hosting?
      hosting_matches?(:production)
    end

    def self.preview_hosting?
      hosting_matches?(:preview)
    end

    def self.hosting_matches?(name)
      raise EnvironmentUndefined if ENV['APP_HOSTING'].blank?

      ENV['APP_HOSTING'].to_sym.eql?(name.to_sym)
    end
  end
end
