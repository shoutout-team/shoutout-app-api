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
#  filename   :string
#  reference  :string           not null
#
# Indexes
#
#  index_uploads_on_key  (key)
#
class Upload < ApplicationRecord
  class AssetNotFound < StandardError; end

  ATTACHMENTS = %i[user_avatar company_picture].freeze
  MAX_UPLOAD_SIZE = 2.megabytes
  SIZE_VALIDATION = { less_than: MAX_UPLOAD_SIZE, message: 'ist größer als 2 MB' }.freeze
  VALID_CONTENT_TYPES = ['image/png', 'image/jpg', 'image/jpeg', 'image/bmp'].freeze
  VARIANTS = { small: '100x100', medium: '400x400', large: '1200x1200' }.freeze

  attr_accessor :force_destroy

  has_one_attached :user_avatar
  has_one_attached :company_picture

  # TODO: We should cleanup stale uploads in a daily job ad midnight #31
  scope :stale, -> { where(created_at: Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day) }

  validates :entity, :kind, presence: true

  validates :user_avatar,
            attached: true, content_type: VALID_CONTENT_TYPES, size: SIZE_VALIDATION,
            if: -> { attachment_name.eql?(:user_avatar) }

  validates :company_picture,
            attached: true, content_type: VALID_CONTENT_TYPES, size: SIZE_VALIDATION,
            if: -> { attachment_name.eql?(:company_picture) }

  # TODO: Remove :generate_reference when securing upload-endpoint #81
  after_initialize :generate_reference
  before_destroy :destroyable?
  after_commit :build_variants

  def self.remap(key:, entity:, kind:)
    instance = find_by(key: key)

    raise Upload::AssetNotFound if instance.nil?

    entity_class = entity.class.name.gsub('Decorator', '')
    asset_blob = ActiveStorage::Blob.find_by(key: key)
    attachment = ActiveStorage::Attachment.find_by(blob_id: asset_blob.id)
    attachment.update_columns(name: kind, record_type: entity_class, record_id: entity.id)
    instance
  end

  def attach_on(asset_storage_name, http_uploaded_file)
    public_send(asset_storage_name).attach(http_uploaded_file)
  end

  def update_attachment_key_for(asset_storage_name)
    blob_key = public_send(asset_storage_name).try(:key)

    return key if blob_key.present? && update(key: blob_key)

    false
  end

  def asset
    public_send(attachment_name)
  end

  def attachment_name
    [entity, kind].join('_').to_sym
  end

  def destroyable?
    return if @force_destroy

    throw(:abort) if Rails.env.production?
  end

  def remove!
    public_send("#{attachment_name}=".to_sym, nil)
    save(validate: false)
    delete
  end

  def build_variants
    # TODO: Non-stored attachment must be handled! #31
    # e.g. try it later on? But we are in an after_commit-callback!!!
    return unless stored?

    VARIANTS.values.each do |sizing|
      public_send(attachment_name).variant(resize: sizing, colorspace: 'RGB').processed
    end
  rescue ActiveStorage::FileNotFoundError => e
    log_not_found_error(e, attachment_name)
  end

  def stored?
    public_send(attachment_name)&.attached?
  end

  def generate_reference
    self.reference = SecureRandom.hex(16) if reference.blank?
  end

  private def log_not_found_error(exception, attachment_name)
    msg = "#{exception.message} on #{self.class.name}##{id} for attachment :#{attachment_name}"
    Loggers::IssueLogger.init.error(msg)
    nil
  end
end
