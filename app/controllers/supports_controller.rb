# frozen_string_literal: true

class SupportsController < ApplicationController
  before_action :set_support, only: %i[show edit update destroy]

  # GET /supports or /supports.json
  def index
    @supports = Support.all
  end

  def new
    @support = Support.new
  end

  # POST /supports or /supports.json
  def create
    @support = Support.new(support_params)

    respond_to do |format|
      if @support.save
        SupportMailer.support_create(@support, current_user).deliver_now
        format.html do
          redirect_to root_path(current_user), notice: 'Your message has been sent. Support will contact you shortly'
        end
        format.json { render :show, status: :created, location: @support }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @support.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_support
    @support = Support.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def support_params
    params.require(:support).permit(:subject, :email, :description, :user_id)
  end
end
