module Api
  module V1
    class AssetsController < Api::BaseController
      protect_from_forgery unless: -> { action_name.to_sym.eql?(:upload) }

      before_action :load_asset, only: %i[show]

      def show
        @asset.present? ? render_json(path: rails_blob_url(@asset)) : head(:not_found)
      end

      # TODO: Must be protected! (only authorized user should be able to upload assets) #81
      def upload
        @service = Assets::UploadService.call(params)

        return render_json(@service.response) if @service.succeeded?

        render_json_unprocessable(error: @service.error, issues: @service.issues)
      rescue ActiveService::ProcessingFailed => e
        # Problem! @service is nil, when an exception is raised
        Loggers::IssueLogger.init.error("UploadService failed to process. cause: #{e.message}")
      end

      private def load_asset
        @asset = ActiveStorage::Blob.find_by(key: params[:key]) if params.key?(:key)
      end
    end
  end
end
