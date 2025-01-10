# app/helpers/application_helper.rb
# frozen_string_literal: true

# application helper module
module ApplicationHelper
  def active_class_controller(link_path)
    current_page?(link_path) ? 'active' : ''
  end
   
  def active_class(controller_name)
    controller_name == params[:controller] ? 'active' : ''
  end
  
  def check_box_helper(picture)
    check_box_tag 'files_ids[]', picture.id, false, class: 'selectable'
  end

  def image_url_download(picture)
    Cloudinary::Utils.private_download_url(picture.key, 'jpg', expires_at: (Time.now + 30.minute).to_time.to_i)
  end

  def files_image_helper(picture)
    Cloudinary::Utils.private_download_url(picture.key, 'jpg') if picture.image?
  end

  def download_zip_helper(zip)
    Cloudinary::Utils.private_download_url("#{zip.key}.#{zip.filename.to_s.partition('.').last}", 'zip',
                                           resource_type: :raw)
  end

  def user_image_helper(picture)
    if picture.image?
      if current_user.admin? || current_user.is_hr
        link_to cl_image_tag(Cloudinary::Utils.private_download_url(picture.key, 'jpg', expires_at: (Time.now + 30.minute).to_time.to_i), class: 'card-img-top card-img-list-display', height: '330'),
                Cloudinary::Utils.private_download_url(picture.key, 'jpg'), attachment: true
      else
        link_to cl_image_tag(Cloudinary::Utils.private_download_url(picture.key, 'jpg'), class: 'card-img-top card-img-list-display', height: '330'),
                Cloudinary::Utils.private_download_url(picture.key, 'jpg'), attachment: true
      end
    end
  end

  def user_video_helper(picture)
    if picture.video?
      video_tag picture.url, controls: true, class: 'card-img-top card-img-list-display', height: '330'
    elsif picture.audio?
      audio_tag picture.url, controls: true, class: 'card-img-top card-img-list-display', height: '330'
    end
  end

  def user_documents_helper(picture)
    unless picture.video? || picture.image? || picture.audio?
      if picture.blob.filename.to_s.include?('pdf')
        link_to cl_image_tag(Cloudinary::Utils.private_download_url(picture.key, 'jpg'), class: 'card-img-top card-img-list-display', height: '330', resource_type: :raw),
                Cloudinary::Utils.private_download_url(picture.key, 'pdf'), attachment: true, resource_type: :raw
      else
        link_to cl_image_tag(Cloudinary::Utils.private_download_url("#{picture.key}.#{picture.blob.filename.to_s.partition('.').last}", 'jpg'), class: 'card-img-top card-img-list-display', height: '330', resource_type: :raw),
                Cloudinary::Utils.private_download_url("#{picture.key}.#{picture.blob.filename.to_s.partition('.').last}", 'pdf'), attachment: true, resource_type: :raw
      end
    end
  end

  def set_notifications
    notifications = Notification.where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end

  def active_day_class(day)
    day == params[:date].to_date.strftime('%A') ? 'text-danger' : ''
  end

  def current_week
    today = Date.today
    start_of_week = today.beginning_of_week
    end_of_week = today.end_of_week
    (start_of_week..end_of_week)
  end

  def get_controller_permission(controller)
    Permission.where(controller:)
  end

  def display_leaves(display_value)
    display_value = display_value.to_i if display_value % 1 == 0.0
  end

  def has_permission_of(user,permission_name)
    user.permissions.pluck(:name).include?(permission_name)
  end

  def display_time(time)
    Time.parse(time).strftime("%I:%M %p")
  end
end
