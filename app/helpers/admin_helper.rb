# app/helpers/admin_helper.rb
# frozen_string_literal: true

# admins helper
module AdminHelper
  def get_day(day_name)
    ((Date.parse(params[:date]).beginning_of_week + Date.parse(day_name).wday - 1))
  end

  def total_h(time)
    get_h = get_m = get_s = 0
    time.each do |time_sheet|
      hours, minutes, seconds = time_sheet.split(':').map(&:to_i)
      get_h += hours
      get_m += minutes
      if get_m > 60
        get_h += 1
        get_m -= 60
      end
      get_s += seconds
      if get_s > 60
        get_m += 1
        get_s -= 60
      end
    end
    "#{get_h}:#{get_m}:#{get_s}"
  end

  def calculate_total_hours(time)
    hours, minutes, seconds = time.split(':').map(&:to_i)
    session[:get_h] = session[:get_h] + hours
    session[:get_m] = session[:get_m] + minutes
    if session[:get_m] > 60
      session[:get_h] = session[:get_h] + 1
      session[:get_m] = session[:get_m] - 60
    end
    session[:get_s] = session[:get_s] + seconds
    if session[:get_s] > 60
      session[:get_m] = session[:get_m] + 1
      session[:get_s] = session[:get_s] - 60
    end
    "#{session[:get_h]}:#{session[:get_m]}:#{session[:get_s]}"
  end

  def get_weekly_project_h(index)
    session[:get_h] = session[:get_m] = session[:get_s] = 0
    calculate_total_hours(@mon_h[index])
    calculate_total_hours(@tue_h[index])
    calculate_total_hours(@wed_h[index])
    calculate_total_hours(@thu_h[index])
    calculate_total_hours(@fri_h[index])
    calculate_total_hours(@sat_h[index])
    totol_h = calculate_total_hours(@sun_h[index])
    session.delete(:get_h)
    session.delete(:get_m)
    session.delete(:get_s)
    totol_h
  end

  def find_weekly_total(project_h)
    total_h = 0
    session[:get_h] = session[:get_m] = session[:get_s] = 0
    project_h.each do |project|
      total_h = calculate_total_hours(project)
    end
    session.delete(:get_h)
    session.delete(:get_m)
    session.delete(:get_s)
    total_h
  end

  def user_remaining_leaves(user)
    ApplyLeave&.sum(:allowed_day)&.- user.leaves.with_deleted.selected_leaves('approved')&.sum(:request_leaves)
  end

  def user_remaining_hours_leaves(user)
    ApplyLeave&.sum(:allowed_hours)&.- user.leaves.with_deleted.selected_leaves('approved')&.sum(:hours)
  end

  def availed_leaves(user)
    user.leaves.with_deleted.selected_leaves('approved')&.sum(:request_leaves)
  end

  def availed_hours(user)
    user.leaves.with_deleted.selected_leaves('approved')&.sum(:hours)
  end

  def pending_leave(user)
    user.leaves.selected_leaves('pending').first
  end

  def pending_request(user)
    user.requests.selected_requests('pending').first
  end
end
