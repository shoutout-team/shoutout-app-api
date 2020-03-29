module CorsAccess
  extend ActiveSupport::Concern

  def cors_preflight_check
    return unless request.method.eql?('OPTIONS')

    #headers['Access-Control-Allow-Origin'] = 'http://localhost'
    headers['Access-Control-Allow-Origin'] = allowed_client_origins
    headers['Access-Control-Allow-Methods'] = allowed_client_methods
    headers['Access-Control-Allow-Headers'] = allowed_headers
    headers['Access-Control-Max-Age'] = allowed_max_age
    render text: '', content_type: 'text/plain'
  end

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    log_origin_access # TODO: Disable logging for GoLive. Log only requests for api-clients #41
    headers['Access-Control-Allow-Origin'] = allowed_client_origins
    headers['Access-Control-Allow-Methods'] = allowed_client_methods
    headers['Access-Control-Allow-Headers'] = allowed_headers
    headers['Access-Control-Max-Age'] = allowed_max_age
  end

  # TODO: Change :allowed_client_origins to FRONTEND_HOSTING for GoLive #41
  private def allowed_client_origins
    #Origin-Code
    #return '*' if App::Hosting.localhost? || @api_client.present? # TODO: || public_api_access_mode?
    #return App::Config::FRONTEND_PREVIEW_HOSTING if App::Hosting.preview_hosting?
    #return App::Config::FRONTEND_PRODUCTION_HOSTING if App::Hosting.production_hosting?

    # New code
    return '*' if Rails.env.development?
    return '*' if public_api_access_mode?
    return '*' if @api_client.present? && @api_client.developer?
    return @api_client.host if @api_client.present? && @api_client.app?
    return App::Config::FRONTEND_PREVIEW_HOSTING if App::Hosting.preview_hosting?
    return App::Config::FRONTEND_PRODUCTION_HOSTING if App::Hosting.production_hosting?

    # Test-code:
    #'http://onedivzero.de'
    #'http://google.de'
    #'*'
    #return '*' if @api_client.present?
  end

  # TODO: Make this configurable #41
  private def allowed_client_methods
    'POST, GET, OPTIONS, PATCH, DELETE'
  end

  # TODO: Make this configurable #41
  private def allowed_headers
    %w[Origin Accept Content-Type X-Requested-With auth_token X-CSRF-Token].join(',')
  end

  # TODO: Make this configurable #41
  private def allowed_max_age
    '1728000'
  end

  private def log_origin_access
    msg = "Request from: '#{request.host}' | Allow-Origin: #{allowed_client_origins}"
    Rails.env.production? ? puts(msg) : Loggers::ClientLogger.init.info(msg)
  end
end
