class UserDesignationsController < ApplicationController
  before_action :set_user_designation, only: %i[ show edit update destroy ]
  before_action :set_authorization, only: %i[new create edit update index]


  # GET /user_designations or /user_designations.json
  def index
    @user_designations = UserDesignation.all
  end

  # GET /user_designations/1 or /user_designations/1.json
  def show
  end

  # GET /user_designations/new
  def new
    @user_designation = UserDesignation.new
  end

  # GET /user_designations/1/edit
  def edit
  end

  # POST /user_designations or /user_designations.json
  def create
    @user_designation = UserDesignation.new(user_designation_params)
    @user_designation.company_id = current_user.company.id
    respond_to do |format|
      if @user_designation.save
        format.turbo_stream do 
          render turbo_stream:
            turbo_stream.replace('users_designations',
                                  partial: 'all_designations',
                                  locals: { user_designations: UserDesignation.all })
        end
        format.html { redirect_to new_user_path, data: { turbo_frame: 'remote_modal' } }
        format.json { render :show, status: :created, location: @user_designation }
      else
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_designation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_designations/1 or /user_designations/1.json
  def update
    respond_to do |format|
      if @user_designation.update(user_designation_params)
        format.turbo_stream do 
          render turbo_stream:
            turbo_stream.replace('users_designations',
                                  partial: 'all_designations',
                                  locals: { user_designations: UserDesignation.all })
        end
        format.html { redirect_to user_designation_url(@user_designation), notice: "User designation was successfully updated." }
        format.json { render :show, status: :ok, location: @user_designation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_designation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_designations/1 or /user_designations/1.json
  def destroy
    @user_designation.destroy

    respond_to do |format|
      format.html { redirect_to user_designations_url, notice: "User designation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_designation
      @user_designation = UserDesignation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_designation_params
      params.require(:user_designation).permit(:name, :company_id)
    end

    def set_authorization
      authorize UserDesignation
    end
end
