# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def index?
    user.super_admin? || has_permission('view_all_projects') if user.present?
  end

  def create?
    user.super_admin? || has_permission('create_project')  if user.present?
  end

  def update?
    user.super_admin? || has_permission('update_project')  if user.present?
  end

  def show?
    user.super_admin? || has_permission('show_project') if user.present?
  end

  def destroy?
    user.super_admin? || has_permission('destroy_project') if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
