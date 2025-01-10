class SendLeaveEmailJob < ApplicationJob
  queue_as :default

  def perform(leave_id, current_user_id, user_id, status)
    leave = Leave.find(leave_id)
    current_user = User.find(current_user_id)
    user = User.find(user_id)
    LeaveMailer.with(leave: leave, current_user: current_user, user: user, status: status).leaves_mailer.deliver_now
  end
end
