module Assets
  class UploadService < ActiveService
    # NOTE: 'rescue ActiveService::ProcessingFailed' is not handled as expected from outer code-base (controller)#31
    # Maybe has to do with using :tap - style-method-invocation?
    # Thus we can only use fail_with and not fail_with!

    METHODS = %i[process].freeze

    ALLOWED_ASSETS = { user: [:avatar], company: [:picture] }.freeze

    attr_reader :params, :attachment_key

    def initialize(params = {})
      @params = params
    end

    def self.call(params, method_name = :process)
      check_service_method!(method_name)
      new(params).tap(&method_name)
    end

    def process
      verify_upload_params!

      return if failed?
      return fail_with(:upload_failed) unless processed_asset&.attached?

      @attachment_key = @upload.update_attachment_key_for(asset_storage)

      return succees! if @attachment_key.present?

      false
    end

    def response
      { response_key => @attachment_key }
    end

    private def processed_asset
      @upload = Upload.new(entity: entity_param, kind: kind_param)
      @upload.attach_on(asset_storage, @params[:asset])
      @upload.save!
      @upload.public_send(asset_storage)
    rescue ActiveRecord::RecordInvalid => e
      @issues = issues_from_record_for(asset_storage)
      nil
    end

    private def verify_upload_params!
      return fail_with(:unkown_endpoint) unless allowed_upload_endpoint?
      return fail_with(:no_data) if @params[:asset].blank?
      return fail_with(:invalid_upload) unless valid_asset_upload?

      true
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

    private def response_key
      "#{kind_param}_key".to_sym
    end
  end
end
