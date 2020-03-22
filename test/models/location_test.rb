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
require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
