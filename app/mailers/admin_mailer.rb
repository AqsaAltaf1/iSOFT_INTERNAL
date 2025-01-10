# app/mailers/admin_mailer.rb
# frozen_string_literal: true

# mailer to send emails to admin
class AdminMailer < ApplicationMailer
  def notify_user(user)
    @user = user
    mail(to: @user.user_email, subject: 'Welcome!')
  end
end
