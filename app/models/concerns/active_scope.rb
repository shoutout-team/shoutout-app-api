module ActiveScope
  extend ActiveSupport::Concern

  included do
    scope :active,    -> { where(active: true) }
    scope :inactive,  -> { where(active: false) }
  end

  def active?
    active
  end

  def inactive?
    !active?
  end
end
