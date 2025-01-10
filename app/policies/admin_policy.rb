# app/policies/admin_policy.rb

# frozen_string_literal: true

# policy for access control of admin
class AdminPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    user.super_admin? if user.present?
  end

  def create?
    user.super_admin? if user.present?
  end

  def update?
    user.super_admin? if user.present?
  end
end
