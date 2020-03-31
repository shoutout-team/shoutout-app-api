# TODO: This get's not invoked. Instead the UserPolicy gets invoked and as fallback ApplicationPolicy #75
class CompanyPolicy < ApplicationPolicy
  class Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.gid == user
  end

  def update?
    record.gid == user
  end
end
