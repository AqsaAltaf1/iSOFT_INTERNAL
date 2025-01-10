class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show ]

  # GET /attendances or /attendances.json
  def index
    @user = current_user
    if params[:date].present?
      @attendances = Attendance.where(
        "DATE(check_in) BETWEEN ? AND ?",
        Date.parse(params[:date]).beginning_of_month,
        Date.parse(params[:date]).end_of_month
      ).where(user_machine_code: @user.machine_code) 
      @options = { start_date:  Date.parse(params[:date]).beginning_of_month, end_date:  Date.parse(params[:date]).end_of_month }
    else
      @options = { start_date: Date.today.beginning_of_month, end_date: Date.today.end_of_month }
      @attendances = Attendance.where(
        "DATE(check_in) BETWEEN ? AND ?",
        Date.today.beginning_of_month,
        Date.today.end_of_month
      ).where(user_machine_code: current_user.machine_code)  
    end
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream:
          turbo_stream.replace('all_attendances',
                                partial: 'all_attendances',
                                locals: { options: @options, attendances: @attendances, user: @user })
      end
      format.html 
    end
  end

  # GET /attendances/1 or /attendances/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attendance_params
      params.require(:attendance).permit(:check_in, :check_out, :user_id, :company_id)
    end
end
