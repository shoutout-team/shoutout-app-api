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
  has_one_attached :user_avatar
  has_one_attached :company_picture

  def attach_on(asset_storage_name, http_uploaded_file)
    public_send(asset_storage_name).attach(http_uploaded_file)
  end

  def update_key!(asset_storage_name)
    blob_key = public_send(asset_storage_name).key
    update(key: blob_key)
    key
  end
end
