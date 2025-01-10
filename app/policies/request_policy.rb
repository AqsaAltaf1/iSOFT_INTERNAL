class RequestPolicy < ApplicationPolicy
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
    user.super_admin? || has_permission('view_all_requests') if user.present?
  end

  def create?
    user.super_admin? || has_permission('create_request') if user.present?
  end

  def update?
    user.super_admin? || record.user == user || has_permission('update_request') if user.present?
  end

  def show?
    user.super_admin? || record.user == user || has_permission('view_request') if user.present?
  end

  def destroy?
    user.super_admin? || record.user == user || has_permission('destroy_request') if user.present?
  end
  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end

end
