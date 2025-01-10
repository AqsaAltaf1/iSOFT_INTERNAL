# app/policies/leave_policy.rb

# frozen_string_literal: true

# writing policy for writing and submitting a leave
class LeavePolicy < ApplicationPolicy
  # scope for access level autherization
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
    user.user? || has_permission("view_all_leaves") || user.super_admin? if user.present?
  end

  def create?
    user.user? || has_permission("create_leave") if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
