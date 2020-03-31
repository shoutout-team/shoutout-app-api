class BackendController < ApplicationController
  before_action :authenticate_user!
  before_action :require_entities, only: %i[index dashboard]

  def index; end

  def dashboard
    render :index
  end

  def require_entities
    @unapproved_companies = Company.with_models.unapproved.ordered
  end
end
