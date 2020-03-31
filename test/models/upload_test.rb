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
#  reference  :string           not null
#
# Indexes
#
#  index_uploads_on_key  (key)
#
require 'test_helper'

class UploadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
