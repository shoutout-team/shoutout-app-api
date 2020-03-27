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
class Company < ApplicationRecord
  include ActiveScope
  include JsonBinaryAttributes

  API_ATTRIBUTES = %i[
    name title category slug properties gid
    postcode city street street_number latitude longitude
  ].freeze

  API_METHODS = %i[category_wording keeper_name picture_url].freeze

  NESTED_PROPERTIES = %i[payment links].freeze

  PAYMENT_OPTIONS = [:paypal, :gofoundme, bank: %i[owner iban]].freeze
  LINKS_OPTIONS = %i[website promotion facebook twitter instagram].freeze

  CATEGORIES = Static::CATEGORIES_ENUM

  enum category: CATEGORIES

  has_jsonb_attributes :properties, :description, :cr_number, :notes, :payment, :links, :permissions

  attr_accessor :picture_key

  belongs_to :user
  has_one_attached :picture

  scope :approved, -> { where(approved: true) }
  scope :with_models, -> { includes(:user) }

  validates :name, :category, :postcode, :city, :street, :street_number, :user_id, presence: true

  after_initialize :define_properties, if: :new_record?
  before_create :generate_gid
  before_create :define_title
  before_create :define_slug

  alias keeper user

  def self.available
    active.approved.with_models
  end

  def self.property_params
    params = { properties: PROPERTIES - NESTED_PROPERTIES }
    params[:properties] << { payment: PAYMENT_OPTIONS }
    params[:properties] << { links: LINKS_OPTIONS }
    params
  end

  def category_wording
    Static::CATEGORIES[category.to_sym]
  end

  def keeper_name
    user.name
  end

  def has_picture?
    picture.attached?
  end

  def picture_url
    return unless has_picture?

    #Rails.env.development? ? picture.key : picture.service_url
    picture.service_url
  end

  def as_json(options = {})
    super({ only: API_ATTRIBUTES, methods: API_METHODS }.merge(options || {}))
  end

  def generate_gid
    self.gid = SecureRandom.hex(16) if gid.blank?
  end

  def define_title
    self.title = name if title.blank?
  end

  # TODO: Append a timestamp or number to :slug, if :slug already exists #6
  def define_slug
    return if slug.present?

    self.slug = sanitize_slug("#{name}-#{city}").parameterize
  end

  def define_properties
    return if properties.any?

    self.properties = {
      description: nil,
      cr_number: nil,
      notes: nil,
      payment: payment_properties_definition,
      links: links_properties_definition,
      permissions: {},
      approval_note: nil
    }
  end

  private def payment_properties_definition
    {
      paypal: nil,
      gofoundme: nil,
      ticket_io: nil,
      bank: {
        owner: nil,
        iban: nil
      }
    }
  end

  private def links_properties_definition
    {
      website: nil,
      promotion: nil,
      facebook: nil,
      twitter: nil,
      instagram: nil
    }
  end

  protected def sanitize_slug(slug_value)
    slug_value.gsub(/[äöüÄÖÜß]/) do |match|
      case match
      when 'ä' then 'ae'
      when 'ö' then 'oe'
      when 'ü' then 'ue'
      when 'Ä' then 'ae'
      when 'Ö' then 'oe'
      when 'Ü' then 'ue'
      when 'ß' then 'ss'
      end
    end
  end
end
