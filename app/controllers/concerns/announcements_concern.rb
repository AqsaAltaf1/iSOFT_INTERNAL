# frozen_string_literal: true

module AnnouncementsConcern
  extend ActiveSupport::Concern
  def render_format
    if params[:status]
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end
end
