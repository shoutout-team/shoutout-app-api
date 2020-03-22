module Api
  class BaseController < ApplicationController
    protect_from_forgery unless: -> { request.format.json? }

    # Add the newly created csrf-token to the page headers
    protected def set_csrf_headers
      return unless request.xhr?

      response.headers['X-CSRF-Token'] = form_authenticity_token.to_s
      response.headers['X-CSRF-Param'] = request_forgery_protection_token.to_s
    end
  end
end
