class ApplyLeavePolicy < ApplicationPolicy
  class Scope < Scope
  end

  def index?
    user.super_admin? || has_permission('view_all_apply_leaves') if user.present?
  end

  def create?
    user.super_admin? || has_permission('create_apply_leave')  if user.present?
  end

  def update?
    user.super_admin? || has_permission('update_apply_leave')  if user.present?
  end

  def show?
    user.super_admin? || has_permission('show_apply_leave') if user.present?
  end

  def destroy?
    user.super_admin? || has_permission('destroy_apply_leave') if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
