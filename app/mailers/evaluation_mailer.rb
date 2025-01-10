# app/mailers/evaluation_mailer.rb
# frozen_string_literal: true

# mailer for evaluations
class EvaluationMailer < ApplicationMailer
  def evaluation_create(user_hr, user, evaluation)
    @user = user
    @user_hr = user_hr
    @evaluation = evaluation
    mail(to: @user, subject: 'Evaluation Created!')
  end

  def evaluation_approved(hr_emails, user_admin, approve_evaluations)
    @user_admin = user_admin
    @approve_evaluations = approve_evaluations
    mail(to: hr_emails, subject: "Evaluation Approved by #{@user_admin.full_name}!")
  end

  def evaluation_active(employee_emails, user_hr, active_evaluation)
    @active_evaluation = active_evaluation
    @user_hr = user_hr
    if employee_emails.present?
      mail(to: employee_emails,
           subject: "Evaluation turned active by #{@user_hr.full_name}!")
    end
  end

  def evaluation_rejected(admin, hr_emails, evaluation)
    @admin = admin
    @rejected_evaluation = evaluation
    mail(to: hr_emails, subject: "Evaluation Rejected by #{@admin.full_name}!")
  end

  def evaluation_completed(hr, user, evaluation_status)
    @user_hr = hr
    @user = user
    @status_evaluation = evaluation_status
    mail(to: @user_hr, subject: 'Evaluation Status Completed')
  end
end
