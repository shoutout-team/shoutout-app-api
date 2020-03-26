module Api
  class BaseController < ApplicationController
    protect_from_forgery unless: -> { request.format.json? }

    before_action :cors_preflight_check
    after_action :cors_set_access_control_headers

    # Add the newly created csrf-token to the page headers
    protected def set_csrf_headers
      return unless request.xhr?

      response.headers['X-CSRF-Token'] = form_authenticity_token.to_s
      response.headers['X-CSRF-Param'] = request_forgery_protection_token.to_s
    end

    # For all responses in this controller, return the CORS access control headers.
    def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = allowed_headers
      headers['Access-Control-Max-Age'] = '1728000'
    end

    def cors_preflight_check
      return unless request.method.eql?('OPTIONS')

      headers['Access-Control-Allow-Origin'] = 'http://localhost'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = allowed_headers
      headers['Access-Control-Max-Age'] = '1728000'
      render text: '', content_type: 'text/plain'
    end

    protected def handle_no_op_error!(error); end

    private def allowed_headers
      %w[Origin Accept Content-Type X-Requested-With auth_token X-CSRF-Token].join(',')
    end
  end
end
