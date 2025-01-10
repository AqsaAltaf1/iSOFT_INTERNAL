class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :user

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
  
  def initialize(current_user,user)
    @current_user = current_user
    @user = user
  end

  def index?
    current_user.admin? || current_user.super_admin? || current_user.is_hr || has_permission('view_all_users') if current_user.present?
  end

  def create?
    current_user.admin? || current_user.super_admin? || current_user.is_hr || has_permission('create_user') if current_user.present?
  end
  
  def show?
    current_user.admin? || current_user.super_admin? || user == current_user || current_user.is_hr || has_permission('view_user') if current_user.present?
  end

  def edit?
    current_user.admin? || current_user.super_admin? || user == current_user || current_user.is_hr || has_permission('edit_user') if current_user.present?
  end

  def destroy?
    current_user.admin? || current_user.super_admin? || current_user.is_hr || has_permission('destroy_user') if current_user.present?
  end

  private

  def has_permission(permission)
    current_user.permissions.exists?(name: permission)
  end
end
