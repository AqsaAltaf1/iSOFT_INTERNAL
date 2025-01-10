# frozen_string_literal: true

class HelpDocumentPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    user.super_admin? || has_permission('create_help_document') if user.present?
  end

  def update?
    user.super_admin? || has_permission('edit_help_document') if user.present?
  end

  def destroy?
    user.super_admin? || has_permission('destroy_help_document') if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
