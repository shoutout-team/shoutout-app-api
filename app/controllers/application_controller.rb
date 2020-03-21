class ApplicationController < ActionController::Base
  include JsonRendering

  layout 'frontend'

  #before_action :authenticate_user!
end
