module CorsAccess
  extend ActiveSupport::Concern

  def cors_preflight_check
    return unless request.method.eql?('OPTIONS')

    headers['Access-Control-Allow-Origin'] = 'http://localhost'
    headers['Access-Control-Allow-Methods'] = allowed_client_methods
    headers['Access-Control-Allow-Headers'] = allowed_headers
    headers['Access-Control-Max-Age'] = allowed_max_age
    render text: '', content_type: 'text/plain'
  end

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    allowed = allowed_client_origins
    Loggers::ClientLogger.init.info("Request from: '#{request.host}' | Allow-Origin: #{allowed}")

    headers['Access-Control-Allow-Origin'] = allowed
    headers['Access-Control-Allow-Methods'] = allowed_client_methods
    headers['Access-Control-Allow-Headers'] = allowed_headers
    headers['Access-Control-Max-Age'] = allowed_max_age
  end

  # TODO: Change :allowed_client_origins to FRONTEND_HOST for GoLive #41
  private def allowed_client_origins
    return '*' if App::Hosting.localhost? || @api_client.present?
    return App::Config::FRONTEND_PREVIEW_HOST if App::Hosting.preview_hosting?
    return App::Config::FRONTEND_PRODUCTION_HOST if App::Hosting.production_hosting?
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
end
