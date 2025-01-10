class AttendanceService
  def initialize()  
  end

  def self.process_attendance(data, company_id)
    data.each do |entry|
      id = entry["EnrollNumber"]
      verify_mode = entry["VerifyMode"]
      timestamp = entry["DateTime"]  
      user = User.find_by(machine_code: id)
      if user.present? 
        @checked_in = Attendance.where('user_machine_code = ? AND DATE(check_in) = ?', id, DateTime.parse(timestamp.strip).strftime("%Y-%m-%d"))
        @checked_out = Attendance.where('user_machine_code = ? AND DATE(check_out) = ?', id, DateTime.parse(timestamp.strip).strftime("%Y-%m-%d"))
        if @checked_in.blank? && @checked_out.blank? && Time.zone.parse(timestamp) >= DateTime.parse(timestamp).change(hour: 18, min: 0, sec: 0)
          Attendance.create!(
                  user_machine_code: id.to_i,
                  check_out: timestamp,
                  company_id: company_id,
                  verify_mode: verify_mode
                  )
        elsif @checked_in.present? && @checked_in.first.check_in != DateTime.parse(timestamp.strip) && @checked_out.blank? 
          Attendance.find_by(id: @checked_in.first.id ).update(check_out: timestamp)
        elsif @checked_in.blank? && @checked_out.blank?
          Attendance.create!(
                  user_machine_code: id.to_i,
                  check_in: timestamp,
                  company_id: company_id,
                  verify_mode: verify_mode
                  )
        end
      end  
    end
    AttendanceDataUploadJob.perform_now(data)
  end
end
  