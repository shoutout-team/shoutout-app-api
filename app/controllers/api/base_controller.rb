module Api
  class BaseController < ApplicationController
    include ClientAccess
    include CorsAccess
    include Pundit
    include AuthenticationSupport

    protect_from_forgery unless: -> { request.format.json? }

    before_action :authenticate_client_access!
    before_action :cors_preflight_check
    after_action :cors_set_access_control_headers

    # Add the newly created csrf-token to the page headers
    protected def set_csrf_headers
      return unless request.xhr?

      response.headers['X-CSRF-Token'] = form_authenticity_token.to_s
      response.headers['X-CSRF-Param'] = request_forgery_protection_token.to_s
    end

    protected def handle_no_op_error!(_error); end
  end
end
