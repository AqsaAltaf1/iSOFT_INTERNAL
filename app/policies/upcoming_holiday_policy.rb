# frozen_string_literal: true

class UpcomingHolidayPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    user.super_admin? || has_permission('create_upcoming_holiday') if user.present?
  end

  def edit?
    user.super_admin? || has_permission('edit_upcoming_holiday') if user.present?
  end

  def destroy?
    user.super_admin? || has_permission('destroy_upcoming_holiday') if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
