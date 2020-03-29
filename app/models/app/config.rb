module App
  class Config
    def self.fetch
      Rails.application.config_for(:app)
    end

    TITLE = fetch[:title]

    DOMAIN = fetch[:domains][:live]
    PRODUCTION_DOMAIN = fetch[:domains][:production]
    STAGING_DOMAIN = fetch[:domains][:staging]
    PREVIEW_DOMAIN = fetch[:domains][:preview]

    PRODUCTION_BACKEND = 'https://' + PRODUCTION_DOMAIN + '/backend'.freeze
    STAGING_BACKEND = 'https://' + STAGING_DOMAIN + '/backend'.freeze
    PREVIEW_BACKEND = 'https://' + PREVIEW_DOMAIN + '/backend'.freeze
    DEVELOPMENT_BACKEND = '/backend'.freeze

    DEBUG_MODE_APP = fetch[:debug][:app]

    FRONTEND_HOST = Rails.application.credentials.dig(:frontend, :domain)
    FRONTEND_PRODUCTION_HOST = Rails.application.credentials.dig(:frontend, :production)
    FRONTEND_PREVIEW_HOST = Rails.application.credentials.dig(:frontend, :preview)
  end
end
