module Backend
  class UploadsController < BackendController
    before_action :require_entity, only: %i[show remove]

    def show; end

    def index
      @entities = Upload.all
    end

    def new
      @entity = Upload.new.decorate
      render :form
    end

    def upload
      @service = Assets::UploadService.call(processable_upload_params)

      return redirect_to backend_list_uploads_path if @service.succeeded?

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

    private def processable_upload_params
      {
        asset: params[:upload].dig(:asset),
        entity: params[:upload].dig(:attachment_name).split('_').first,
        kind: params[:upload].dig(:attachment_name).split('_').last,
      }
    end
  end
end
