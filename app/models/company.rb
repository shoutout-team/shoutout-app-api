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
#
# Indexes
#
#  index_companies_on_active      (active)
#  index_companies_on_category    (category)
#  index_companies_on_latitude    (latitude)
#  index_companies_on_longitude   (longitude)
#  index_companies_on_name        (name)
#  index_companies_on_properties  (properties) USING gin
#  index_companies_on_slug        (slug)
#  index_companies_on_user_id     (user_id)
#
class Company < ApplicationRecord
  include ActiveScope
  include JsonBinaryAttributes

  CATEGORIES = Static::CATEGORIES_ENUM

  enum category: CATEGORIES

  has_jsonb_attributes :properties, :description, :cr_number, :notes, :payment, :links

  belongs_to :user

  validates :name, :category, :postcode, :city, :street, :street_number, :user_id, presence: true

  after_initialize :define_properties, if: :new_record?
  before_create :define_title
  before_create :define_slug

  alias keeper user

  def define_title
    self.title = name if title.blank?
  end

  # TODO: Append a timestamp or number to :slug, if :slug already exists #6
  def define_slug
    return if slug.present?

    self.slug = "#{city}-#{name}".parameterize
  end

  def define_properties
    return if properties.any?

    self.properties = {
      description: nil,
      cr_number: nil,
      notes: nil,
      payment: {
        paypal: nil,
        gofoundme: nil,
        iban: nil
      },
      links: {
        website: nil,
        facebook: nil,
        twitter: nil,
        instagram: nil
      }
    }
  end
end
