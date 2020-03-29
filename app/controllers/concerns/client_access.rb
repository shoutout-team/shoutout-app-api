module ClientAccess
  extend ActiveSupport::Concern

  # This is required for CORS-Policy in order to allow special clients to access the API
  # via 'Access-Control-Allow-Origin' (in module CorsAccess).
  # If no api-key is provided, then there is nothing to verify.
  def authenticate_client_access!
    return if api_key_from_params.nil?

    return require_api_client if access_from_localhost?
    return require_api_client if access_from_preview_hosting? && restricted_api_access_mode?
    return require_api_client if access_from_production_hosting?
    return require_api_client if access_from_public_hosting?

    true # Do not halt otherwise
  end

  def require_api_client
    @api_client = App::Client.available.find_by(api_key: api_key_from_params)
  end

  protected def access_from_localhost?
    # NOTE: request.headers['Origin'] => e.g. 'http://localhost:3006'
    request.host.eql?('localhost')
  end

  protected def access_from_preview_hosting?
    App::Config::FRONTEND_PREVIEW_HOSTING.eql?(hosting_from_request)
  end

  protected def access_from_production_hosting?
    App::Config::FRONTEND_PRODUCTION_HOSTING.eql?(hosting_from_request)
  end

  protected def access_from_public_hosting?
    App::Config::FRONTEND_HOSTING.eql?(hosting_from_request)
  end

  protected def restricted_api_access_mode?
    App::Hosting.api_access_mode.eql?(:restricted)
  end

  protected def public_api_access_mode?
    return App::Hosting.api_access_mode.eql?(:public) if Rails.env.production?

    # TODO: Test this with restricting #41
    ENV['SHOUTOUT_APP_API_ACCESS_MODE'].try(:to_sym).eql?(:public)
  end

  protected def hosting_from_request
    "#{request.protocol}#{request.host}"
  end

  protected def api_key_from_params
    params[:api_key]
  end
end
