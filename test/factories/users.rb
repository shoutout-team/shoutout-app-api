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
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_developer_key         (developer_key)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_gid                   (gid) UNIQUE
#  index_users_on_preferences           (preferences) USING gin
#  index_users_on_properties            (properties) USING gin
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :user do
  end
end
