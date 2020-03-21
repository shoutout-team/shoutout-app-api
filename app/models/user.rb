class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { guest: 0, user: 1, administrator: 2, developer: 3 }

  scope :administrative, -> { where(role: %i[administrator developer]) }
  scope :users, -> { where(role: %i[guest user]) }

  after_initialize :define_user_role

  def define_user_role
    self.role = :user if role.blank?
  end

  def admin?
    administrator? || developer?
  end

  def to_s
    name || email
  end
end
