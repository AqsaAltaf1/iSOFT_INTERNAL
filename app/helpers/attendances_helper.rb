module AttendancesHelper
  def check_status(attendance, user)
    if attendance.check_out.nil?
      if attendance&.check_in&.strftime("%H:%M:%S") != Date.today 
        image_tag(asset_path('images/MissingOut.png'))
      elsif attendance&.check_in&.strftime("%H:%M:%S") > user&.shift&.start_time.strftime("%H:%M:%S")
        image_tag(asset_path('images/LateNess.png'))
      else
        image_tag(asset_path('images/present.png'))
      end
    else
      if attendance&.check_out&.strftime("%H:%M:%S") < user&.shift&.end_time.strftime("%H:%M:%S") 
        image_tag(asset_path('images/EarlyOut.png')) 
      elsif attendance&.check_in&.strftime("%H:%M:%S") > user&.shift&.start_time.strftime("%H:%M:%S")
        image_tag(asset_path('images/LateNess.png'))
      else
        image_tag(asset_path('images/present.png'))
      end
    end
  end

  def get_user_attendances(machine_code, start_date, end_date)
    Attendance.user_attendance(machine_code, start_date, end_date)
  end

end
