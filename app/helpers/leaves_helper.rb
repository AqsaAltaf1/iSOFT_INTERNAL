# app/helpers/leaves_helper.rb
# frozen_string_literal: true

# leaves helper module
module LeavesHelper
  def status_pending
    if params[:leave_status].present?
      params[:leave_status].downcase == 'pending' ? 'text-danger' : ''
    else
      'text-danger'
    end
  end

  def status_approved
    if params[:leave_status].present?
      params[:leave_status].downcase == 'approved' ? 'text-danger' : ''
    else
      ''
    end
  end

  def status_rejected
    if params[:leave_status].present?
      params[:leave_status].downcase == 'rejected' ? 'text-danger' : ''
    else
      ''
    end
  end

  def get_name
    if params[:checked_by].present?
      if params[:checked_by].to_i == current_user.id
        'You'
      else
        User.find(params[:checked_by]).full_name
      end
    else
      'You'
    end
  end

  # def remaining_leaves
  #     ApplyLeave&.sum(:allowed_day)-current_user.leaves.selected_leaves('approved')&.sum(:request_leaves)
  # end

  # def remaining_leaves_of_type(type,user)
  #     ApplyLeave.find(type).allowed_day-user.leaves.selected_leaves('approved').slected_type(type)&.sum(:request_leaves)
  # end

  def leave_image(leave)
    link_to cl_image_tag(Cloudinary::Utils.private_download_url(leave.key, 'jpg'), height: '50'),
            Cloudinary::Utils.private_download_url(leave.key, 'jpg'), attachment: true
  end

  def remaining_leaves_details(type, user)
    leave_type = ApplyLeave.find(type)&.allowed_leave_type
    remaining_leaves = if leave_type == "short"
                         current_user.is_hr || current_user.admin? ? ApplyLeave.remaining_leaves_of_short_type(type, user || current_user) : ApplyLeave.remaining_leaves_of_short_type(type, current_user)
                       else
                         current_user.is_hr || current_user.admin? ? ApplyLeave.remaining_leaves_of_type(type, user || current_user) : ApplyLeave.remaining_leaves_of_type(type, current_user)
                       end
    "Remaining #{leave_type == "short" ? "hours" : "Leaves"}: #{display_leaves(remaining_leaves)}"
  end
end
