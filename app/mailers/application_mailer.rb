# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'iSOFTSTUDIOS <noreply@isoftstudios.com>'
  layout 'mailer'
  helper :application
end
