class LocationsController < ApplicationController
  before_action :set_location, only: %i[ show edit update destroy ]
  before_action :set_city_state, only: [:new, :create]

  def index
    @locations = Location.all
  end

  def show
  end

  def new
    @location = Location.new
    respond_to do |format|
      format.json { render json: { message: 'Success', cities: @cities, states: @states }, status: :ok }
      format.html
    end
  end

  def edit
  end

  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to new_user_path, notice: "Location was successfully created." }
        format.json { render :show, status: :created, location: @location }
      else
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to location_url(@location), notice: "Location was successfully updated." }
        format.json { render :show, status: :ok, location: @location }
      else
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:work_location, :country, :state, :city, :zip_code, :address)
    end

    def set_city_state
      @countries = CS.countries.map { |key, value| [value, key] }
      @selected_country = params[:country]
      @selected_state = params[:state]
      params[:country] ? @states = CS.states(params[:country]).map { |key, value| [value, key] } : @states = CS.states('US').map { |key, value| [value, key] }
      params[:state] ? @cities = CS.cities(params[:state],params[:country]).each { |value| [value] } : @cities = CS.cities(:AK, :US).each { |value| [value] }
    end
end
