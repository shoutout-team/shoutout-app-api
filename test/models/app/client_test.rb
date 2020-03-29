# == Schema Information
#
# Table name: app_clients
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  kind       :integer          default("0"), not null
#  api_key    :string           not null
#  host       :string
#  user_id    :integer
#  approved   :boolean          default("false"), not null
#  active     :boolean          default("false"), not null
#  properties :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_app_clients_on_active      (active)
#  index_app_clients_on_api_key     (api_key) UNIQUE
#  index_app_clients_on_approved    (approved)
#  index_app_clients_on_properties  (properties) USING gin
#  index_app_clients_on_user_id     (user_id)
#
require 'test_helper'

class App::ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
