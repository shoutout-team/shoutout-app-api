module Assets
  class UploadService < ActiveService
    METHODS = %i[process].freeze

    ALLOWED_ASSETS = { user: [:avatar], company: [:picture] }.freeze

    attr_reader :params, :asset_key, :error

    def initialize(params = {})
      @params = params
    end

    def self.call(params, method_name = :process)
      check_service_method!(method_name)
      new(params).tap(&method_name)
    end

    def process
      verify_upload_params!

      if processed_asset.attached?
        @upload.update_key!(asset_storage)
        @asset_key = @upload.key
      else
        fail_with!(:upload_failed)
      end

      true
    end

    private def processed_asset
      @upload = Upload.new(entity: entity_param, kind: kind_param)
      @upload.attach_on(asset_storage, @params[:asset])
      @upload.public_send(asset_storage)
    end

    private def verify_upload_params!
      fail_with!(:unkown_endpoint) unless allowed_upload_endpoint?
      fail_with!(:no_data) if @params[:asset].blank?
      fail_with!(:invalid_upload) unless valid_asset_upload?
    end

    private def allowed_upload_endpoint?
      allowed_entity? && allowed_asset_kind?
    end

    private def allowed_entity?
      ALLOWED_ASSETS.key?(entity_param)
    end

    private def allowed_asset_kind?
      ALLOWED_ASSETS[entity_param].include?(kind_param)
    end

    private def valid_asset_upload?
      @params[:asset].is_a?(ActionDispatch::Http::UploadedFile)
    end

    private def asset_storage
      [entity_param, kind_param].join('_').to_sym
    end

    private def entity_param
      @params[:entity].try(:to_sym)
    end

    private def kind_param
      @params[:kind].try(:to_sym)
    end
  end
end
