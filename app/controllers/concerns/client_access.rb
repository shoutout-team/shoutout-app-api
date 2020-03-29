module ClientAccess
  extend ActiveSupport::Concern

  def authenticate_client_access!
    return verify_client_token if access_from_localhost?
    return verify_client_token if access_from_preview_hosting? && restricted_api_access_mode?
    return verify_client_token if access_from_production_hosting?
    return verify_client_token if access_from_public_hosting?

    false
  end

  def verify_client_token
    return false if api_key_from_params.nil?

    @api_client = nil
    true
  end

  # App::Hosting.api_access_mode

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

  protected def hosting_from_requestg
    "#{request.protocol}#{request.host}"
  end

  protected def api_key_from_params
    params['api-key']
  end
end
