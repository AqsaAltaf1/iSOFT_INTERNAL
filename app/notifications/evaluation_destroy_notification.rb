# frozen_string_literal: true

# To deliver this notification:
#
# LeaveApprovalNotification.with(post: @post).deliver_later(current_user)
# LeaveApprovalNotification.with(post: @post).deliver(current_user)

# notification for evaluation destroy
class EvaluationDestroyNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    if params[:hr].present? || params[:admin].present?
      "<strong>#{params[:user].full_name}</strong> has  Destroyed <strong>#{params[:evaluation_title]}</strong> Evaluation.".html_safe
    end
  end

  def url
    evaluations_path(is_delete: params[:evaluation_title])
  end
end
