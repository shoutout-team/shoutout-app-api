module Backend
  class UploadsController < BackendController
    before_action :require_entity, only: %i[remove]

    def index
      @entities = Upload.all
    end

    def remove
      @entity.remove!
      redirect_to backend_list_uploads_path
    end

    private def require_entity
      @entity = Upload.find(params[:id]).try(:decorate)
    end
  end
end
