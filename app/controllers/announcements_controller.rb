# frozen_string_literal: true

class AnnouncementsController < ApplicationController
  include AnnouncementsConcern
  before_action :authenticate_user!
  before_action :set_announcement, only: %i[show edit update destroy]
  before_action :set_authorization, only: %i[new edit destroy]

  def index
    @status = params[:status].present? ? params[:status].downcase : 'announcements'
    @announcements = Announcement.all.order(created_at: :desc)
    @upcoming_holidays = UpcomingHoliday.all.order(created_at: :desc)
    render_format
  end

  def show
    mark_announcement_notifications_as_read
  end

  def new
    @announcement = Announcement.new
  end

  def edit; end

  def create
    @announcement = Announcement.new(announcement_params)

    respond_to do |format|
      if @announcement.save
        announcement_notify_recipient(@announcement, current_user, AnnouncementNotification)
        users = User.where.not(id: current_user.id)
        users.each { |user| AnnouncementMailer.announcements_mailer(@announcement, current_user, user).deliver_later }
        format.html { redirect_to announcement_url(@announcement), notice: 'Announcement was successfully created.' }
        format.json { render :show, status: :created, location: @announcement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @announcement.update(announcement_params)
        format.html { redirect_to announcement_url(@announcement), notice: 'Announcement was successfully updated.' }
        format.json { render :show, status: :ok, location: @announcement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to announcements_url, notice: 'Announcement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def announcement_notify_recipient(announcement, announcement_user, type)
    announcementusers = User.where.not(id: announcement_user.id)
    announcementusers.each do |user|
      type.with(announcement:, user: announcement_user).deliver(user)
      get_notifications(user)
      SendNotificationJob.perform_later(@unread.first, user, @read.count)
    end
  end

  private

  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  def announcement_params
    params.require(:announcement).permit(:title, :body, files: [])
  end

  def set_authorization
    authorize Announcement
  end
end
