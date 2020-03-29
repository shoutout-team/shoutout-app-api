module ClientAccess
  extend ActiveSupport::Concern

  def authenticate_client_access!
    #verify_client_token if access_from_localhost?
    #verify_client_token if access_from_preview? && restricted_api_access_mode?
    #restricted_api_access_mode?
    true
  end

  def verify_client_token
    return false if params[:api_key].nil?

    @api_client = nil
    true
  end

  # App::Hosting.api_access_mode

  protected def access_from_localhost?
    request.host.eql?('localhost')
  end

  protected def restricted_api_access_mode?
    App::Hosting.api_access_mode.eql?(:restricted)
  end
end
