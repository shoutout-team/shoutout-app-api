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
#  latitude      :decimal(10, 6)
#  longitude     :decimal(10, 6)
#  properties    :jsonb            not null
#  active        :boolean          default("true"), not null
#  user_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  gid           :string           not null
#  approved      :boolean          default("false"), not null
#
# Indexes
#
#  index_companies_on_active      (active)
#  index_companies_on_approved    (approved)
#  index_companies_on_category    (category)
#  index_companies_on_gid         (gid) UNIQUE
#  index_companies_on_latitude    (latitude)
#  index_companies_on_longitude   (longitude)
#  index_companies_on_name        (name)
#  index_companies_on_properties  (properties) USING gin
#  index_companies_on_slug        (slug)
#  index_companies_on_user_id     (user_id)
#
FactoryBot.define do
  factory :company do
    name { 'Name' }
    title { '' }
    category { 0 }
    postcode { 'MyString' }
    city { 'MyString' }
    street { 'MyString' }
    street_number { 'MyString' }
    description { 'MyText' }
    latitude { 9.99 }
    longitude { 9.99 }
    user_id { 1 }
  end
end
