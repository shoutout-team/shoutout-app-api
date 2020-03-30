module Backend
  class UsersController < BackendController
    before_action :require_user, only: %i[approve reject edit update]

    def index
      @entities = User.keepers.with_models
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
        redirect_to root_path
      else
        render :form
      end
    end

    def update
      if @entity.update(user_params)
        redirect_to root_path
      else
        render :form
      end
    end

    def approve
      @company.update(approved: true)
      redirect_to root_path
    end

    def reject
      @company.update(approved: false)
      redirect_to root_path
    end

    private def user_params
      params.require(:user).permit(:email, :name, :role, :developer_key)
    end

    private def require_user
      @user = User.find(params[:id])
      @entity = @user.decorate
    end
  end
end
