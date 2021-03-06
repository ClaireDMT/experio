class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def payement?
    record.user == user
  end

  def accept?
    record.experience.user == user
  end

  def decline?
    record.experience.user == user
  end
end
