module Approval
  extend ActiveSupport::Concern

  included do
    scope :approved, -> { where(approved: true) }
    scope :unapproved, -> { where(approved: false) }
  end

  def enable!
    update(active: true)
  end

  def approve!
    update(approved: true)
  end

  def disable!
    update(active: false)
  end

  def reject!
    update(approved: false)
  end

  def unapproved?
    !approved?
  end
end
