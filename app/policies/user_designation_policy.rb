class UserDesignationPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
  end
    def index?
      user.super_admin? || has_permission('view_all_user_designations') if user.present?
    end
  
    def create?
      user.super_admin? || has_permission('create_user_designation')  if user.present?
    end
  
    def update?
      user.super_admin? || has_permission('update_user_designation')  if user.present?
    end
  
    def show?
      user.super_admin? || has_permission('show_user_designation') if user.present?
    end
  
    private
  
    def has_permission(permission)
      user.permissions.exists?(name: permission)
    end
end
