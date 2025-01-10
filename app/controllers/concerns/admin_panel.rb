# app/controllers/concerns/admin_panel.rb
# frozen_string_literal: true

# concern for admin side, inside application controller
module AdminPanel
  def hash_project(week_date, status)
    day = Date.parse(week_date).at_beginning_of_week
    @day_vise_log = []
    @project_vise_log = {}

    weekly_project_ids = @user.time_sheets.get_project_ids_with_status(status, week_date)
    all_projects = Project.where(id: weekly_project_ids)
    all_projects.each do |project|
      @project_vise_log[project.name] = {}
    end
    7.times do
      formatted_date = day.strftime('%d %B %Y-%A')
      day_name = day.strftime('%A')

      idss = @user.time_sheets.get_day_base_project_ids(day.to_s, status)
      day_projects = Project.where(id: idss)

      projects = []
      total_time_log = 0

      @project_vise_log.each_key do |project_name|
        @project_vise_log[project_name].merge!({ day_name => '0:0:0' })
      end

      day_projects.each do |project|
        pro_time_sheets = project.time_sheets.where(status:, date: day)
        pro_time_log = set_hours(pro_time_sheets)

        projects.push({
                        data: project,
                        time_log: pro_time_log
                      })

        @project_vise_log[project.name].merge!({
                                                 day_name => pro_time_log
                                               })

        hours, minutes, seconds = pro_time_log.split(':').map(&:to_i)
        total_time_log += (hours * 60 * 60) + (minutes * 60) + seconds
      end

      minutes, seconds = total_time_log.divmod(60)
      hours, minutes = minutes.divmod(60)

      formatted_time_log = "#{hours}:#{minutes}:#{seconds}"
      @day_vise_log.push({ date: formatted_date, projects:, total_time: formatted_time_log })

      day = day.next_day
    end
  end
end
