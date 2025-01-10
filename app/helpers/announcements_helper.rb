# frozen_string_literal: true

module AnnouncementsHelper
  def announcement_image(announcement)
    link_to cl_image_tag(Cloudinary::Utils.private_download_url(announcement.key, 'jpg'), height: '50'),
            Cloudinary::Utils.private_download_url(announcement.key, 'jpg'), attachment: true
  end

  def announcements
    if params[:status].present?
      params[:status].downcase == 'announcements' ? 'text-danger' : ''
    else
      'text-danger'
    end
  end

  def upcomingholidays
    if params[:status].present?
      params[:status].downcase == 'upcomingholidays' ? 'text-danger' : ''
    else
      ''
    end
  end

  def events
    if params[:status].present?
      params[:status].downcase == 'events' ? 'text-danger' : ''
    else
      ''
    end
  end
end
