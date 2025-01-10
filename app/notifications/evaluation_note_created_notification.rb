# frozen_string_literal: true

class EvaluationNoteCreatedNotification < Noticed::Base
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
    "<strong>Reminder: #{params[:sender].full_name}</strong> has  added a note".html_safe if params[:sender].present?
  end

  def url
    evaluation_path(Evaluation.find(params[:evaluation].id), notification_id: params[:evaluation].id)
  end
end
