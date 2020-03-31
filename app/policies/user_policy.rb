class UserPolicy < ApplicationPolicy
  class Scope
    def resolve
      scope.all
    end
  end

  def update?
    record.gid == user
  end
end
