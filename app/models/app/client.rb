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
module App
  class Client < ApplicationRecord
    include ActiveScope
    include JsonBinaryAttributes

    enum kind: { app: 0, developer: 1 }

    belongs_to :user, optional: true

    scope :approved, -> { where(approved: true) }

    after_initialize :define_properties, if: :new_record?
    after_initialize :generate_api_key, if: :new_record?

    def self.available
      active.approved
    end

    def generate_api_key
      self.api_key = SecureRandom.hex(16) if api_key.blank?
    end

    def disable!
      update(active: false)
    end

    def reject!
      update(approved: false)
    end

    def define_properties
      return if properties.any?

      self.properties = {}
    end
  end
end
