# frozen_string_literal: true

# To deliver this notification:
#
# LeaveApprovalNotification.with(post: @post).deliver_later(current_user)
# LeaveApprovalNotification.with(post: @post).deliver(current_user)

# notification for active evaluation
class EvaluationActiveNotification < Noticed::Base
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
  def message
    if params[:user].present?
      # @user=User.find_by(id: params[:user])
      "<strong>#{params[:hr].full_name}</strong> has  Activated <strong>#{params[:evaluation].title}</strong> Evaluation.".html_safe
    end
  end

  def url
    employee_evaluation_evaluations_path(evaluation_notification: params[:evaluation].id)
  end
end
