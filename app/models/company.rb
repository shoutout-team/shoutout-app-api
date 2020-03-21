# == Schema Information
#
# Table name: companies
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  title         :string           not null
#  category      :integer          not null
#  slug          :string           not null
#  postcode      :string           not null
#  city          :string           not null
#  street        :string           not null
#  street_number :string           not null
#  description   :text
#  latitude      :decimal(10, 6)
#  longitude     :decimal(10, 6)
#  properties    :jsonb            not null
#  user_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_companies_on_category    (category)
#  index_companies_on_latitude    (latitude)
#  index_companies_on_longitude   (longitude)
#  index_companies_on_name        (name)
#  index_companies_on_properties  (properties) USING gin
#  index_companies_on_slug        (slug)
#  index_companies_on_user_id     (user_id)
#
class Company < ApplicationRecord
  validates :name, :category, :postcode, :city, :street, :street_number, :user_id, presence: true
end
