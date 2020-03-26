module UploadPostProcessing
  extend ActiveSupport::Concern

  # TODO: Should be done in a background-job #31
  private def post_process_asset_for(entity, kind:)
    attachment_key = attachment_key_from_params(entity, kind)

    return if attachment_key.blank?

    upload = Upload.remap(key: attachment_key, entity: entity, kind: kind)
    upload.delete
  rescue Upload::AssetNotFound => e
    # TODO: Handle Error for Upload::AssetNotFound #31
    handle_no_op_error!(e)
  end

  private def attachment_key_from_params(entity, name)
    param_key_name = "#{name}_key".to_sym
    params[entity.model_name.param_key][param_key_name]
  end
end
