# app/helpers/home_helper.rb
# frozen_string_literal: true

# home helper module
module HomeHelper
  def announcement_count
    Announcement&.count
  end

  def leaves_count
    current_user.user? && !current_user.is_hr ? current_user.leaves&.selected_leaves('pending')&.count : Leave&.selected_leaves('pending')&.count
  end

  def time_sheets_count
    current_user.user? && !current_user.is_hr ? current_user.time_sheets&.where(status: 'pending')&.count : TimeSheet&.where(status: 'pending')&.count
  end

  def company_assets_count
    CompanyAsset&.count
  end

  def evaluations_count
    if current_user.admin?
      Evaluation&.status('pending')&.count
    elsif current_user.is_hr
      Evaluation&.status('approved')&.count
    else
      Evaluation&.status('active')&.count
    end
  end

  def employees_count
    User&.count
  end

  def attachements_count
    current_user.attachments&.count
  end

  def projects_count
    Project&.count
  end

  def leave_types_count
    ApplyLeave&.count
  end
end
