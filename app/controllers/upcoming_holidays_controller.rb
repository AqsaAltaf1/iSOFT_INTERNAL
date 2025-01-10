# frozen_string_literal: true

class UpcomingHolidaysController < ApplicationController
  before_action :set_upcoming_holiday, only: %i[show edit update destroy]
  before_action :authorize_upcoming_holiday, except: %i[index show]

  def index
    @upcoming_holidays = UpcomingHoliday.all
  end

  def show; end

  def new
    @upcoming_holiday = UpcomingHoliday.new
  end

  def edit; end

  def create
    @upcoming_holiday = UpcomingHoliday.new(upcoming_holiday_params)

    respond_to do |format|
      if @upcoming_holiday.save
        format.html { redirect_to upcoming_holidays_url, notice: 'holiday is successfully created.' }
        format.json { render :show, status: :created, location: @upcoming_holiday }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @upcoming_holiday.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @upcoming_holiday.update(upcoming_holiday_params)
        format.html { redirect_to upcoming_holiday_url(@upcoming_holiday), notice: 'holiday was successfully updated.' }
        format.json { render :show, status: :ok, location: @upcoming_holiday }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @upcoming_holiday.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @upcoming_holiday.destroy
    respond_to do |format|
      format.html { redirect_to upcoming_holidays_url, notice: 'Upcoming holiday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_upcoming_holiday
    @upcoming_holiday = UpcomingHoliday.find(params[:id])
  end

  def upcoming_holiday_params
    params.require(:upcoming_holiday).permit(:title, :date, :description)
  end

  def authorize_upcoming_holiday
    authorize UpcomingHoliday
  end
end
