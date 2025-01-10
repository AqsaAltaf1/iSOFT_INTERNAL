# frozen_string_literal: true

class AnnouncementMailer < ApplicationMailer
  def announcements_mailer(announcement, announcement_user, user)
    @announcement = announcement
    @user = user
    @announcement_user = announcement_user
    mail(to: @user.email, subject: 'New Announcement')
  end
end
