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
#
# Indexes
#
#  index_uploads_on_key  (key)
#
FactoryBot.define do
  factory :upload do
    entity { 'MyString' }
    kind { 'MyString' }
    key { 'MyString' }
  end
end
