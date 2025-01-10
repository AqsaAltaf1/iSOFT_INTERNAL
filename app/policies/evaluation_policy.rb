# frozen_string_literal: true

class EvaluationPolicy < ApplicationPolicy
  class Scope < Scope
  end

  def index?
    user.super_admin? || has_permission('view_all_evaluations') if user.present?
  end

  def show?
    user.super_admin? || has_permission('view_evaluation') if user.present?
  end

  def completed_evaluation?
    user.super_admin? || has_permission('completed_evaluation') if user.present?
  end

  def create?
    has_permission('create_evaluation') if user.present?
  end

  def update?
    has_permission('edit_evaluation') if user.present?
  end

  def user_evaluation?
    has_permission('user_evaluation') if user.present?
  end

  def employee_evaluation?
    has_permission('employee_evaluation') if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end
end
