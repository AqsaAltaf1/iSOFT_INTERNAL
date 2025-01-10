# frozen_string_literal: true

module Timesheet
  module CallBackModule
    include ActiveSupport::Concern
    def get_timesheets
      params[:get_date] = TimeSheet.get_selected_date(params[:data], params[:get_date].to_s)
      if params[:user_id].to_i != 0
        @time_sheets = TimeSheet.where(status: params[:status], date: params[:get_date], user_id: params[:user_id])
      else
        @time_sheets = if current_user.user? && !current_user.is_hr
                         policy_scope(TimeSheet.current_date(params[:get_date],
                                                             params[:status].present? ? params[:status].downcase : 'draft'))
                       else
                         policy_scope(TimeSheet.includes(:project).includes(:user).where(status:
                                                                              params[:status].present? ? params[:status].downcase : 'approved'))
                       end
      end
      mark_time_sheet_notifications_as_read
      render_format(params[:get_date])
    end

    def validate_date
      time_sheet = TimeSheet.find(params[:id])
      unless (Date.today.at_beginning_of_week..Date.today.at_end_of_week).cover?(time_sheet.date) && (time_sheet.status == 'draft' || time_sheet.status == 'archived')
        redirect_to time_sheets_path, notice: 'You Can Not Edit or Delete This TimeSheet'
      end
    end

    def render_format(selected_date)
      authorize TimeSheet
      if params[:get_user] || params[:n_time_sheet] || params[:id]
        respond_to do |format|
          format.html
        end
      elsif (selected_date == Date.today || params[:get_date]) && !params[:data] && !params[:status] && !params[:next_day] && !params[:prev_day] && !params[:return_today] && !params[:approval_request]
        respond_to do |format|
          format.html
        end
      else
        respond_to do |format|
          format.js
        end
      end
    end

    def approval_request
      if params[:approval_request]
        @time_sheets = TimeSheet.current_week_time_sheets(current_user.id)
        if @time_sheets.present?
          @time_sheets.each do |time_sheet|
            time_sheet.update(status: 'pending')
          end
          notify_recipient(@time_sheets.last, current_user, TimeSheetNotification)
        end
      end
    end

    def get_add_remove_archived
      if params[:time_sheet]
        TimeSheet.find(params[:time_sheet]).update(status: params[:status])
        params[:status] = if params[:status] == 'draft'
                            'archived'
                          else
                            'draft'
                          end
      end
    end

    def check_admin
      params[:status] = 'Pending' if params[:get_user]
    end
  end
end
