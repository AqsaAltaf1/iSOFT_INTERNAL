# frozen_string_literal: true

module EvaluationHelper
  def status_is_pending?
    params[:status].blank? || params[:status].capitalize == 'Pending'
  end

  def status_is_approved?(status)
    status&.capitalize == 'Approved'
  end
end
