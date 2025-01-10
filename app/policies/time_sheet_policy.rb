# app/policies/time_sheet_policy.rb

# frozen_string_literal: true

# policy for timesheets authrerization
class TimeSheetPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.present?
        if user.user? && !user.is_hr
          scope.where(user_id: user.id)
        else
          scope.all
        end
      end
    end
  end

  def index?
    has_permission('view_all_time_sheets') || user.super_admin? if user.present?
  end

  def create?
    has_permission('create_time_sheet') if user.present?
  end

  def update?
    has_permission('update_time_sheet') if user.present?
  end

  def show?
    has_permission('show_time_sheet') || user.super_admin? if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
