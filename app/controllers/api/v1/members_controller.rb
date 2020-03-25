module Api
  module V1
    class MembersController < Api::BaseController
      include Users::ResourceStates

      after_action :set_csrf_headers, only: :login

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
          render_json
        else
          render_json_error(@user.errors)
        end
      end

      private def login_params
        params.require(:user).permit(:email, :password)
      end

      private def signup_params
        params.require(:user).permit(:name, :email, :password, :avatar_key)
      end

      # TODO: Remove :approved_signup_params after MVP #10
      private def approved_signup_params
        signup_params.merge(approved: true)
      end

      private def authenticated?
        @user.present? && @user.valid_password?(params[:user][:password])
      end

      private def render_succeded_login
        render_json(user: @user.public_attributes)
      end

      private def post_process_asset_for(entity, kind:)
        return if asset_param_for(kind).blank?

        upload = Upload.remap(key: asset_param_for(kind), entity: entity, kind: kind)
        upload.delete
      rescue Upload::AssetNotFound
        # TODO: Handle Error #31
      end

      # private def post_process_asset_for(entity, kind:)
      #   return if asset_param_for(kind).blank?

      #   asset_blob = ActiveStorage::Blob.find_by(key: asset_param_for(kind))
      #   attachment = ActiveStorage::Attachment.find_by(blob_id: asset_blob.id)
      #   upload = attachment.record
      #   attachment.update_columns(name: kind, record_type: entity.class.name, record_id: entity.id)
      #   upload.delete
      # end

      private def asset_param_for(name)
        asset_key_name = "#{name}_key".to_sym
        params[:user][asset_key_name]
      end
    end
  end
end
