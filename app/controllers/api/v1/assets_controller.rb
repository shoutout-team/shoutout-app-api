module Api
  module V1
    class AssetsController < Api::BaseController
      UPLOAD_MAPPING = { user: [:avatar], company: [:picture] }.freeze

      before_action :load_asset, only: %i[show]

      def show
        @asset.present? ? render_json(path: rails_blob_url(@asset)) : head(:not_found)
      end

      def upload
        return render_json_unprocessable(error: :unkown_endpoint) unless allowed_upload_endpoint?
        return render_json_unprocessable(error: :no_data) if params[:asset].blank?
        return render_json_unprocessable(error: :invalid_upload) unless valid_asset_upload?

        if processed_asset.attached?
          render_json(asset_key: @upload.update_key!(asset_storage))
        else
          return render_json_unprocessable(error: :processing_failed)
        end
      end

      private def load_asset
        @asset = ActiveStorage::Blob.find_by(key: params[:key]) if params.key?(:key)
      end

      private def processed_asset
        @upload = Upload.new(entity: entity_param, kind: kind_param)
        @upload.attach_on(asset_storage, params[:asset])
        @upload.public_send(asset_storage)
      end

      private def allowed_upload_endpoint?
        allowed_entity? && allowed_asset_kind?
      end

      private def allowed_entity?
        UPLOAD_MAPPING.keys.include?(entity_param)
      end

      private def allowed_asset_kind?
        UPLOAD_MAPPING[entity_param].include?(kind_param)
      end

      private def valid_asset_upload?
        params[:asset].is_a?(ActionDispatch::Http::UploadedFile)
      end

      private def asset_storage
        [entity_param, kind_param].join('_').to_sym
      end

      private def entity_param
        params[:entity].try(:to_sym)
      end

      private def kind_param
        params[:kind].try(:to_sym)
      end
    end
  end
end
