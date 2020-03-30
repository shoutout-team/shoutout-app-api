class UserDecorator < BackendDecorator
  def role_collection
    User::ROLES.keys
  end
end
