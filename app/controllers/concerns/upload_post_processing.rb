module UploadPostProcessing
  extend ActiveSupport::Concern

  private def post_process_asset_for(entity, kind:)
    asset_key = asset_key_from_params(entity, kind)

    return if asset_key.blank?

    upload = Upload.remap(key: asset_key, entity: entity, kind: kind)
    upload.delete
  rescue Upload::AssetNotFound
    # TODO: Handle Error for Upload::AssetNotFound #31
  end

  private def asset_key_from_params(entity, name)
    asset_key_name = "#{name}_key".to_sym
    params[entity.model_name.param_key][asset_key_name]
  end
end
