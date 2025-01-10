class CreateAttendanceJob < ApplicationJob
  queue_as :default

  def perform(data, company)
    company.update(last_sync_at: Time.current.in_time_zone('Islamabad'))
    AttendanceService.process_attendance(data, company.id)
  end
end
