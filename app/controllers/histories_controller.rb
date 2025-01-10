# frozen_string_literal: true

class HistoriesController < ApplicationController
  before_action :set_history, only: %i[show edit update]

  # GET /histories/new
  def new
    @company_asset = CompanyAsset.find(params[:company_asset_id])
    @history = @company_asset.histories.build
  end

  # POST /histories or /histories.json
  def create
    @history = History.new(history_params)
    @company_asset = CompanyAsset.find(history_params[:company_asset_id])
    @history.assigned_by = current_user.full_name
    @user = User.find_by(id: @history.user_id)
    respond_to do |format|
      if @history.save
        HistoryNotification.with(history: @history, current_user: current_user).deliver(@user)
        format.html do
          redirect_to company_asset_url(@history.company_asset), notice: 'History was successfully created.'
        end
        format.json { render :show, status: :created, location: @history }
      else
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def show
    mark_history_notifications_as_read
  end

  def update
    respond_to do |format|
      if @history.update(history_params)
        format.html do
          redirect_to company_asset_url(@history.company_asset), notice: 'History was successfully updated.'
        end
        format.json { render :show, status: :created, location: @history }
      else
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_history
    @history = History.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def history_params
    params.require(:history).permit(:company_asset_id, :assigned_by, :given_date, :return_date, :user_id,
                                    :given_condition, :return_condition)
  end
  
end
