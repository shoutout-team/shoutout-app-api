module Api
  class V1Controller < ApplicationController
    protect_from_forgery unless: -> { request.format.json? }

    def load
      render_json(spa_load_response)
    end

    def companies
      render_json(Company.active)
    end

    def categories
      render_json(Static::CATEGORIES)
    end

    def keepers
      render_json(User.available.pluck(:id, :email, :name))
    end

    # TODO: Use :signup_params after MVP #10
    def signup
      @user = User.create(approved_signup_params)

      if @user.persisted?
        render_json
      else
        render_json_error(@user.errors)
      end
    end

    private def signup_params
      params.require(:user).permit(:name, :email, :password)
    end

    # TODO: Remove :approved_signup_params after MVP #10
    private def approved_signup_params
      signup_params.merge(approved: true)
    end

    private def spa_load_response
      {
        keepers: User.available.pluck(:id, :email, :name),
        categories: Static::CATEGORIES,
        companies: Company.active
      }
    end
  end
end
