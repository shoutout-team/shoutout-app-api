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
#  token                  :string           not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_preferences           (preferences) USING gin
#  index_users_on_properties            (properties) USING gin
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_token                 (token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { guest: 0, user: 1, administrator: 2, developer: 3 }

  has_one :company, dependent: :destroy

  scope :administrative, -> { where(role: %i[administrator developer]) }
  scope :users, -> { where(role: %i[guest user]) }
  scope :keepers, -> { where(role: %i[user]) }
  scope :approved, -> { where(approved: true) }

  after_initialize :define_user_role
  before_create :generate_token

  def self.available
    keepers.approved
  end

  def define_user_role
    self.role = :user if role.blank?
  end

  def generate_token
    self.token = SecureRandom.hex(16) if token.blank?
  end

  def admin?
    administrator? || developer?
  end

  def keeper?
    user
  end

  def to_s
    name || email
  end
end
