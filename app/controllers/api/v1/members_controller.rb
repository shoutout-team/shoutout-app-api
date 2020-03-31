module Api
  module V1
    class MembersController < Api::BaseController
      include UploadPostProcessing
      include Users::ResourceStates

      after_action :set_csrf_headers, only: :login
      after_action :verify_authorized, only: :update

      # Required for future securing upload-endpoint #81
      # New workflow for signup (post-golive):
      # - acquire_token before signup
      # - will be delivered as :keeper_token from SPA in :signup_params
      # - use :keeper_token for uploads before signup is proceeded (and verify it)
      # - allow pre-signup-uploads only for given :keeper_token (prevents not Reply-Attacks against upload-endpoint)
      def acquire_token
        render_json(token: SecureRandom.hex(16))
      end

      # TODO: Missing case-handling for :confirmed? and :approved?
      def login
        @user = User.find_for_database_authentication(email: params[:user][:email])
        authenticated? ? render_succeded_login : render_json_forbidden(:invalid_login)
      end

      # TODO: Use :signup_params after MVP #10
      def signup
        @user = User.create(approved_signup_params.merge(role: :user))

        if @user.persisted?
          post_process_asset_for(@user, kind: :avatar)
          render_succeded_login
        else
          render_json_error(@user.errors)
        end
      end

      def update
        @keeper = User.available.find_by(gid: update_params[:keeper_token])
        authorize(@keeper)

        return render_json_forbidden(:unknown_keeper) if @keeper.nil?

        #return render_json_forbidden(:unapproved_keeper) unless @keeper.approved?

        if @keeper.update_with_avatar(update_params)
          replace_asset_for(@keeper, kind: :avatar) if @keeper.update_avatar?
          render_json(result: @keeper)
        else
          render_json_unprocessable(error: :invalid, issues: @keeper.errors.details)
        end
      end

      private def login_params
        params.require(:user).permit(:email, :password)
      end

      private def signup_params
        params.require(:user).permit(:name, :email, :password, :keeper_token, :avatar_key)
      end

      private def update_params
        params.require(:user).permit(:name, :avatar_key, :change_avatar, :keeper_token, properties: [:avatar_key])
      end

      # TODO: Remove :approved_signup_params after MVP #10
      private def approved_signup_params
        signup_params.merge(approved: true)
      end

      private def authenticated?
        @user.present? && @user.valid_password?(params[:user][:password])
      end

      private def render_succeded_login
        render_json(user: @user.public_attributes, token: generate_token(@user))
      end
    end
  end
end
