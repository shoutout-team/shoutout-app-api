# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           not null
#  name                   :string
#  role                   :integer          default("0"), not null
#  properties             :jsonb            not null
#  preferences            :jsonb            not null
#  approved               :boolean          default("false"), not null
#  encrypted_password     :string           not null
#  remember_created_at    :datetime
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default("0"), not null
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  gid                    :string           not null
#  developer_key          :string
#  active                 :boolean          default("true"), not null
#
# Indexes
#
#  index_users_on_active                (active)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_developer_key         (developer_key)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_gid                   (gid) UNIQUE
#  index_users_on_preferences           (preferences) USING gin
#  index_users_on_properties            (properties) USING gin
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  include ActiveScope
  include JsonBinaryAttributes
  include Approval

  ROLES = { guest: 0, user: 1, administrator: 2, developer: 3, root: 4 }.freeze

  API_ATTRIBUTES = %i[name gid].freeze
  API_METHODS = %i[company_name avatar_url avatar_key].freeze

  has_jsonb_attributes :properties, :avatar_key

  attr_accessor :change_avatar, :keeper_token

  enum role: ROLES

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :company, dependent: :destroy
  has_one_attached :avatar

  scope :administrative, -> { where(role: %i[administrator developer]) }
  scope :users, -> { where(role: %i[guest user]) }
  scope :keepers, -> { where(role: %i[user]) }
  scope :ordered, -> { order(:created_at) }
  scope :with_models, -> { includes(:company) }
  scope :keeper_list, -> { keepers.with_models.ordered }

  after_initialize :define_properties, if: :new_record?
  after_initialize :define_user_role
  before_save :check_developer_key
  before_create :generate_gid

  def self.available
    keepers.approved.with_models
  end

  def self.fetchable
    active.with_models
  end

  def check_developer_key
    self.developer_key = nil unless developer?
  end

  # rubocop:disable Rails/Delegate
  def company_name
    company.try(:name)
  end
  # rubocop:enable Rails/Delegate

  def update_with_avatar(attributes)
    update(attributes)
  end

  def update_avatar?
    change_avatar
  end

  def has_avatar?
    # TODO: This fires a query on each call, resulting in N+1 queries on SPA-Fetch #67
    avatar.attached?
    # And should be replaced by a check on avatar_key-property
    # avatar_key.present?
  end

  # Deprecated: we solve this in an endpoint #9
  # def avatar_url
  #   return unless avatar.attached?

  #   #avatar.service_url if Rails.env.production?
  #   avatar.service.send(:path_for, avatar.key) if Rails.env.development?

  # rescue URI::InvalidURIError => e
  #   # TODO: Log issue
  # end

  def avatar_url
    return unless has_avatar?

    #Rails.env.development? ? avatar.key : avatar.service_url
    avatar.try(:service_url)
  end

  def as_json(options = {})
    super({ only: API_ATTRIBUTES, methods: API_METHODS }.merge(options || {}))
  end

  def generate_password(length = 10)
    chars = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a + '!@#$%^&*'.split('')
    chars.sort_by { rand }.join[0...length]
  end

  def define_properties
    return if properties.any?

    self.properties = {
      avatar_key: nil
    }
  end

  def define_user_role
    self.role = :user if role.blank?
    sefl.developer_key = SecureRandom.hex(16) if developer_key.blank? && developer?
  end

  def generate_gid
    self.gid = SecureRandom.hex(16) if gid.blank?
  end

  def admin?
    administrator? || developer?
  end

  def keeper?
    user
  end

  def public_attributes
    attributes.symbolize_keys.slice(*API_ATTRIBUTES)
  end

  def to_s
    name || email
  end
end
