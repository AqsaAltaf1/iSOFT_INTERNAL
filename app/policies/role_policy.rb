class RolePolicy < ApplicationPolicy
    # NOTE: Be explicit about which records you allow access to!
  class Scope < Scope
  end

  def index?
    user.super_admin? || has_permission('view_all_roles') if user.present?
  end

  def create?
    user.super_admin? || has_permission('create_role')  if user.present?
  end

  def update?
    user.super_admin? || has_permission('update_role')  if user.present?
  end

  def show?
    user.super_admin? || has_permission('show_role') if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
