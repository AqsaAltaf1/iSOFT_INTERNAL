# frozen_string_literal: true

class AnnouncementPolicy < ApplicationPolicy
  # scope for access level autherization
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.present?
        if user.user?
          scope.where(user_id: user.id)
        else
          scope.all
        end
      end
    end
  end

  def index?
    has_permission('view_all_announcements') || user.super_admin? if user.present?
  end

  def create?
    user.super_admin? || has_permission('create_announcement') if user.present?
  end

  def update?
    user.super_admin? || has_permission('update_announcement') if user.present?
  end

  def destroy?
    user.super_admin? || has_permission('destroy_announcement') if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
