module Api
  class BaseController < ApplicationController
    protect_from_forgery unless: -> { request.format.json? }

    before_filter :cors_preflight_check
    after_filter :cors_set_access_control_headers

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
        headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With auth_token X-CSRF-Token}.join(',')
        headers['Access-Control-Max-Age'] = "1728000"
    end

    def cors_preflight_check
      if request.method == "OPTIONS"
        headers['Access-Control-Allow-Origin'] = 'http://localhost'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With auth_token X-CSRF-Token}.join(',')
        headers['Access-Control-Max-Age'] = '1728000'
        render :text => '', :content_type => 'text/plain'
      end
    end
  end
end
