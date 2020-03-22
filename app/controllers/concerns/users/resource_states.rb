module Users
  # TODO: Remove me ... is currently not required #10
  module ResourceStates
    protected def account_exists?
      load_resource.present?
    end

    protected def authenticated?
      resource.present? && resource.valid_password?(params[:user][:password])
    end

    protected def confirmed?
      resource.present? && resource.confirmed_at.present?
    end

    protected def unconfirmed?
      resource.confirmed_at.nil?
    end

    # Required if devise-module :password_expirable is used
    protected def needs_password_change?
      resource.present? && resource.respond_to?(:need_change_password) && resource.need_change_password?
    end
  end
end
