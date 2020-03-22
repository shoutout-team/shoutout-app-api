module Users
  # TODO: Remove me ... is currently not required #10
  module AuthenticationSupport
    extend ActiveSupport::Concern

    include Users::ResourceStates

    protected def load_resource
      self.resource = User.find_for_database_authentication(email: params[:user][:email])
    end

    protected def perform_login_for(resource)
      sign_in('user', resource)

      redirect_to session[:previous_location] || root_path
    end
  end
end
