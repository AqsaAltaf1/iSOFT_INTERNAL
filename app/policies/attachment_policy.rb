# frozen_string_literal: true

class AttachmentPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.present?
        if user.user? && !user.is_hr
          scope.where(attachable_id: user.id).order(created_at: :desc)
        elsif user.is_hr
          scope.where(attachable_id: User.employees_that_are_not_hrs.joins(:attachments))
        elsif user.admin?
          scope.where.not(attachable_id: @user.id)
        end
      end
    end
  end
end
