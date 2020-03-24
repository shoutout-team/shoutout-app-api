module Api
  module V1
    class AssetsController < Api::BaseController
      before_action :load_asset, only: %i[show]

      def show
        @asset.present? ? render_json(path: rails_blob_url(@asset)) : head(:not_found)
      end

      private def load_asset
        @asset = ActiveStorage::Blob.find_by(key: params[:key]) if params.key?(:key)
      end
    end
  end
end