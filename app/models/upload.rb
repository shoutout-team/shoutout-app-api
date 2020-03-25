# == Schema Information
#
# Table name: uploads
#
#  id         :bigint           not null, primary key
#  entity     :string           not null
#  kind       :string           not null
#  key        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_uploads_on_key  (key)
#
class Upload < ApplicationRecord
  class AssetNotFound < StandardError; end

  attr_accessor :force_destroy

  has_one_attached :user_avatar
  has_one_attached :company_picture

  before_destroy :destroyable?

  def self.remap(key:, entity:, kind:)
    instance = find_by(key: key)

    raise Upload::AssetNotFound if instance.nil?

    asset_blob = ActiveStorage::Blob.find_by(key: key)
    attachment = ActiveStorage::Attachment.find_by(blob_id: asset_blob.id)
    attachment.update_columns(name: kind, record_type: entity.class.name, record_id: entity.id)
    instance
  end

  def attach_on(asset_storage_name, http_uploaded_file)
    public_send(asset_storage_name).attach(http_uploaded_file)
  end

  def store_key_for(asset_storage_name)
    blob_key = public_send(asset_storage_name).try(:key)
    update(key: blob_key) if blob_key.present?
    key
  end

  def destroyable?
    return if @force_destroy

    throw(:abort) if Rails.env.production?
  end
end
