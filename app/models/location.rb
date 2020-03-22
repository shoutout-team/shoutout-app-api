# == Schema Information
#
# Table name: locations
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  postcode       :string           not null
#  federate_state :string           not null
#  osm_id         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_locations_on_federate_state  (federate_state)
#  index_locations_on_name            (name)
#  index_locations_on_osm_id          (osm_id)
#  index_locations_on_postcode        (postcode)
#
class Location < ApplicationRecord
  API_ATTRIBUTES = %i[name postcode federate_state osm_id].freeze
  API_METHODS = %i[].freeze

  validates :name, :postcode, :federate_state, :osm_id, presence: true

  def as_json(options = {})
    super({ only: API_ATTRIBUTES, methods: API_METHODS }.merge(options || {}))
  end
end
