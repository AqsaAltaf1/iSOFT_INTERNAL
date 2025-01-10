# frozen_string_literal: true

class CompanyAssetsController < ApplicationController
  before_action :set_company_asset, only: %i[show edit update destroy]
  before_action :authenticate_user!
  # GET /company_assets or /company_assets.json
  def index
    @company_assets = CompanyAsset.all
    authorize @company_assets
  end

  # GET /company_assets/1 or /company_assets/1.json
  def show
    @histories = @company_asset.histories.includes(:user).all
    authorize @company_asset
  end

  # GET /company_assets/new
  def new
    @company_asset = CompanyAsset.new
    authorize @company_asset
  end

  # GET /company_assets/1/edit
  def edit
    authorize @company_asset
  end

  # POST /company_assets or /company_assets.json
  def create
    @company_asset = CompanyAsset.new(company_asset_params)
    @company_asset.added_by = current_user.full_name
    respond_to do |format|
      if @company_asset.save
        format.html { redirect_to company_assets_path, notice: 'Company asset is successfully created.' }
        format.json { render :show, status: :created, location: @company_asset }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_asset.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_assets/1 or /company_assets/1.json
  def update
    respond_to do |format|
      if @company_asset.update(company_asset_params)
        format.html { redirect_to company_asset_path(@company_asset), notice: 'Company asset is successfully updated.' }
        format.json { render :show, status: :ok, location: @company_asset }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_asset.errors, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_assets/1 or /company_assets/1.json
  def destroy
    @company_asset.destroy

    respond_to do |format|
      format.html { redirect_to company_assets_path, notice: 'Company asset is successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_assets
    @company_assets = current_user.company_assets
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company_asset
    @company_asset = CompanyAsset.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def company_asset_params
    params.require(:company_asset).permit(:model, :company_assets_type, :purchase_date, :status, :price, :description, :name, :unique_identifier, :user_id,
                                          :added_by, images: [])
  end
end
