# frozen_string_literal: true

class CompanyAssetPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def initialize(user, company_asset)
    @user = user
    @company_asset = company_asset
  end

  def index?
    user.super_admin? || has_permission('view_all_company_assets') if user.present?
  end

  def show?
    user.super_admin? || has_permission('view_company_assets') || match_assets(@company_asset) if user.present?
  end

  def create?
    user.super_admin? || has_permission('create_company_asset') if user.present?
  end

  def update?
    user.super_admin? || has_permission('edit_company_asset') if user.present?
  end

  private

  def has_permission(permission)
    user.permissions.exists?(name: permission)
  end

  def match_assets(company_asset)
    if @user.company_assets.present?
      user_assets = @user.company_assets.pluck(:id)
      company_asset_id = company_asset.id
      user_assets.include?(company_asset_id)
    end  
  end
end
