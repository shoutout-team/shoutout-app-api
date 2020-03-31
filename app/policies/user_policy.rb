class UserPolicy < ApplicationPolicy
  class Scope < Scope
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
