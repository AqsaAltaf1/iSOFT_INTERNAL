# app/mailers/leave_mailer.rb
# frozen_string_literal: true

# mailer for leaves
class LeaveMailer < ApplicationMailer

  def leaves_mailer
    @leave = params[:leave]
    @status = params[:status]
    @current_user = params[:current_user]
    @user = params[:user]
    if @status.present?
      mail(to: @user.email, subject: "Update Status of Leave request by #{@leave.user.full_name}")
    else
      mail(to: @user.email, subject: "Leave request by #{@leave.user.full_name}")
    end
  end

  def leave_reminder_email(leave, _leave_users, user)
    @leave = leave
    @user = user
    mail(to: @user.email, subject: "Leave Request Reminder by #{leave.user.full_name}")
    admins = User.where(user_type: :admin).pluck(:email)
    mail to: admins, subject: "Leave Request Reminder by #{leave.user.full_name}"
  end
end
