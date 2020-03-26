module ClientAccess
  extend ActiveSupport::Concern

  def authenticate_client_access!
    verify_client_token if local_host_access?
  end

  def verify_client_token
    true
  end

  protected def local_host_access?
    request.host.eql?('localhost')
  end
end
