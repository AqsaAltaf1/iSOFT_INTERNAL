# app/mailers/user_mailer.rb
# frozen_string_literal: true

# mailer for users
class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password Reset'
  end

  def user_create
    @user = params[:user]
    @receiver = params[:receiver]
    mail(to: @receiver.email, subject: params[:subject])
  end
end
