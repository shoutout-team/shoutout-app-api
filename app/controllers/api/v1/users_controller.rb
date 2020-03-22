module Api
  module V1
    class UsersController < Api::BaseController
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
    end
  end
end
