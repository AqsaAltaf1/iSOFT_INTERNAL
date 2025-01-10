# frozen_string_literal: true

class SupportMailer < ApplicationMailer
  def support_create(order, user)
    @order = order
    @user = user
    mail(to: 'hello@isoftstudios.com', subject: @order.subject, from: @user.email)
  end
end
