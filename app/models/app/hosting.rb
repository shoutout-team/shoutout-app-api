module App
  module Hosting
    class EnvironmentUndefined < StandardError; end

    def self.production_hosting?
      hosting_matches?(:production)
    end

    def self.preview_hosting?
      hosting_matches?(:preview)
    end

    def self.localhost?
      Rails.env.development?
    end

    def self.hosting_matches?(name)
      return if Rails.env.development?

      raise EnvironmentUndefined if ENV['APP_HOSTING'].blank?

      ENV['APP_HOSTING'].to_sym.eql?(name.to_sym)
    end

    def self.api_access_mode
      return :public if localhost?

      ENV['APP_API_ACCESS_MODE'].to_sym
    end
  end
end
