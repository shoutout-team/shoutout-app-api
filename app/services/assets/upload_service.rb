module Assets
  class UploadService < ActiveService
    # NOTE: 'rescue ActiveService::ProcessingFailed' is not handled as expected from outer code-base (controller)#31
    # Maybe has to do with using :tap - style-method-invocation?
    # Thus we can only use fail_with and not fail_with!

    METHODS = %i[process].freeze

    ALLOWED_ASSETS = { user: [:avatar], company: [:picture] }.freeze

    ACCEPTABLE_META_DATA = ['data:image/png;base64', 'data:image/jpg;base64', 'data:image/jpeg;base64'].freeze

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
      @upload.attach_on(asset_storage, asset_data)
      @upload.save! unless failed?
      @upload.public_send(asset_storage)
    rescue ActiveRecord::RecordInvalid => e
      @issues = issues_from_record_for(e.record, asset_storage)
      nil
    end

    # TODO: Checkout any possible security-issues with processing binary-data
    # TODO: Refactor asset_data #60
    private def asset_data
      return @params[:asset] if file_upload?

      require 'base64'

      meta_data, binary_data = @params[:asset].split(',')

      return fail_with(:unacceptable_base64_content) unless ACCEPTABLE_META_DATA.include?(meta_data)

      blob = Base64.decode64(binary_data)
      image = MiniMagick::Image.read(blob)
      filename = params[:filename] || generate_filename_from(meta_data)

      { io: File.open(image.tempfile), filename: filename }

    rescue MiniMagick::Invalid => e
      # TODO: Do not expose details to frontend. Log error instead #60
      fail_with(:unprosseable_upload, e.message)
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
      file_upload? || binary_upload?
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

    private def file_upload?
      @params[:asset].is_a?(ActionDispatch::Http::UploadedFile)
    end

    private def binary_upload?
      @params[:asset].starts_with?('data:image/')
    end

    private def generate_filename_from(meta_data)
      "asset-#{Time.now.to_i}." + meta_data.gsub('data:image/', '').gsub(';base64', '')
    end
  end
end
