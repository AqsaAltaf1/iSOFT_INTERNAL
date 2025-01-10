# frozen_string_literal: true

module HomeConcern
  extend ActiveSupport::Concern

  def update_status_of_user
    if params[:id].present?
      @user = User.find(params[:id])
      @user.update(status: params[:status])
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
