module Backend
  class UsersController < BackendController
    include UploadPostProcessing

    before_action :require_user, only: %i[approve reject edit update destroy]

    def index
      @entities = User.keeper_list
    end

    def add
      @entity = User.new.decorate
      render :form
    end

    def edit
      render :form
    end

    def create
      @entity = User.create(user_params).try(:decorate)

      if @entity.persisted?
        process_changed_avatar
        redirect_to backend_list_users_path
      else
        render :form
      end
    end

    def update
      if @entity.update(user_params)
        process_changed_avatar
        redirect_to backend_list_users_path
      else
        render :form
      end
    end

    def destroy
      @entity.destroy
      redirect_to backend_list_users_path
    end

    def approve
      @company.update(approved: true)
      redirect_to root_path
    end

    def reject
      @company.update(approved: false)
      redirect_to root_path
    end

    private def process_changed_avatar
      return if @entity.avatar_key_before_last_save.eql?(user_params[:avatar_key])

      if user_params[:avatar_key].blank?
        @entity.update(avatar: nil)
      else
        remap_upload(user_params[:avatar_key], @entity, :avatar)
      end
    end

    private def user_params
      params.require(:user).permit(:email, :name, :role, :developer_key, :avatar_key, :password)
    end

    private def require_user
      @user = User.find(params[:id])
      @entity = @user.decorate
    end
  end
end
