module App
  module Hosting
    class EnvironmentUndefined < StandardError; end

    def self.production_hosting?
      hosting_matches?(:production)
    end

    def self.preview_hosting?
      hosting_matches?(:preview)
    end

    # TODO: Rename APP_ENVIRONMENT to APP_HOSTING and update Setup-Process too #50
    def self.hosting_matches?(name)
      raise EnvironmentUndefined if ENV['APP_ENVIRONMENT'].blank?

      ENV['APP_ENVIRONMENT'].to_sym.eql?(name.to_sym)
    end
  end
end
