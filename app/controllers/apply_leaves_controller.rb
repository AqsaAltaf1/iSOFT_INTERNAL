# frozen_string_literal: true

class ApplyLeavesController < ApplicationController
  before_action :set_apply_leave, only: %i[show edit update destroy]
  before_action :set_authorization, only: %i[new create edit update index show]


  def index
    @apply_leaves = ApplyLeave.all
  end

  def show; end

  def new
    @apply_leave = ApplyLeave.new
  end

  def edit; end

  def create
    @apply_leave = ApplyLeave.new(apply_leave_params)
    respond_to do |format|
      if @apply_leave.save
        format.html { redirect_to apply_leave_url(@apply_leave), notice: 'Apply leave was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @apply_leave.update(apply_leave_params)
        format.html { redirect_to apply_leave_url(@apply_leave), notice: 'Apply leave was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @apply_leave.destroy
    respond_to do |format|
      format.html { redirect_to apply_leaves_url, notice: 'Apply leave was successfully destroyed.' }
    end
  end

  private

  def set_apply_leave
    @apply_leave = ApplyLeave.find(params[:id])
  end

  def set_authorization
    authorize ApplyLeave
  end

  def apply_leave_params
    params.require(:apply_leave).permit(:allowed_leave_type, :allowed_day, :allowed_hours, :paid_type)
  end
end
