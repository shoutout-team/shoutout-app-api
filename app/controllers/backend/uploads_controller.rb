module Backend
  class UploadsController < BackendController
    before_action :require_entity, only: %i[remove]

    def index
      @entities = Upload.all
    end

    def new
      @entity = Upload.new.decorate
      render :form
    end

    def upload
      @service = Assets::UploadService.call(params[:upload])

      return redirect_to backend_list_uploads_path if @service.succeeded?

      bp

      @entity = Upload.new.decorate
      @entity.errors.add(:base, @service.error)
      render :form
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
