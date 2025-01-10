# frozen_string_literal: true

class SMaiupportlerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def support_create
    SupportMailer.support_create
  end
end
