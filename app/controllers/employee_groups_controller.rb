class EmployeeGroupsController < ApplicationController
  before_action :set_employee_group, only: %i[ show edit update destroy ]

  def index
    @employee_groups = EmployeeGroup.all
  end

  def show
  end

  def new
    @employee_group = EmployeeGroup.new
    @time_policy = @employee_group.build_time_policy
  end 

  def edit
  end

  def create
    @employee_group = EmployeeGroup.new(employee_group_params)
    respond_to do |format|
      if @employee_group.save
        format.html { redirect_to employee_group_url(@employee_group), notice: "Employee group was successfully created." }
        format.json { render :show, status: :created, location: @employee_group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @employee_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @employee_group.update(employee_group_params)
        format.html { redirect_to employee_group_url(@employee_group), notice: "Employee group was successfully updated." }
        format.json { render :show, status: :ok, location: @employee_group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @employee_group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee_group.destroy

    respond_to do |format|
      format.html { redirect_to employee_groups_url, notice: "Employee group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_employee_group
      @employee_group = EmployeeGroup.find(params[:id])
    end

    def employee_group_params
      params.require(:employee_group).permit(:code, :name, :description, :company_id, employee: [],
      time_policy_attributes: [ missing_attendance:{}, late_arrival:{}, early_out:{}, hours_per_day:{}, missing_swipe:{}, overtime_policy:{}])
    end
end
