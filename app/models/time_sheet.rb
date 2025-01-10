# app/models/time_sheet.rb
# frozen_string_literal: true

# time sheet's date validator model
class TimeAndDateValidator < ActiveModel::Validator
  def validate(record)
    if record.time.strftime('%M').to_i.zero? && record.time.strftime('%H').to_i.zero?
      record.errors.add :base, 'Time must be greater than zero'
    end
    unless (Date.today.at_beginning_of_week..Date.today).cover?(record.date)
      if record.date > Date.today
        record.errors.add :base, 'You cannot create Timesheet for coming days'
      else
        record.errors.add :base, 'You can only create Timesheet in current week'
      end
    end
  end
end

# time sheet's model
class TimeSheet < ApplicationRecord
  acts_as_tenant :company
  validates_presence_of :date, :description, :project_id
  validates_length_of :description, minimum: 50
  validates_with TimeAndDateValidator, on: :create
  belongs_to :user
  belongs_to :project
  has_noticed_notifications model_name: 'Notification'
  scope :current_week_time_sheets, lambda { |user_id|
                                     where(user_id:, date: Date.today.at_beginning_of_week..Date.today.at_end_of_week, status: 'draft')
                                   }
  scope :check_submit_button_view, lambda { |user_id, date|
                                     where(user_id:, date:, status: 'draft')
                                   }
  scope :current_date, ->(date, status) { where(date: "#{date}%", status:) }
  scope :get_approve_week, lambda { |start_week, end_week|
                             where(status: 'pending', date: (Date.parse(start_week).at_beginning_of_week..Date.parse(end_week).at_end_of_week))
                           }
  scope :get_timesheet, lambda { |project, date|
                          where(status: 'pending', date: (Date.parse(date).at_beginning_of_week..Date.parse(date).at_end_of_week), project_id: project.id)
                        }
  scope :get_project_ids, lambda { |date, status|
                            where(status:, date: (Date.parse(date).at_beginning_of_week..Date.parse(date).at_end_of_week)).uniq.pluck(:project_id)
                          }
  scope :get_day_base_project_ids, lambda { |date, status|
                                     where(status:, date: Date.parse(date)).uniq.pluck(:project_id)
                                   }

  scope :get_project_ids_with_status, lambda { |status, date|
                                        where(status:, date: (Date.parse(date).at_beginning_of_week..Date.parse(date).at_end_of_week)).uniq.pluck(:project_id)
                                      }

  enum :status, %i[draft approved archived rejected pending]
  after_initialize :set_default_status, if: :new_record?
  def set_default_status
    self.status ||= :draft
  end

  def self.validate_timesheet_time(time_sheet_params, user)
    @time_sheet = user.time_sheets.build(time_sheet_params)
    new_time = @time_sheet.time.strftime('%H:%M')
    date1 = @time_sheet.date
    @time_sheets = user.time_sheets.where(date: date1)
    timesheet_time = []
    @time_sheets.each do |time_sheet|
      time = time_sheet.time.strftime('%H:%M')
      timesheet_time.push(time)
    end
    timesheet_time.push(new_time)
    time1 = timesheet_time.sum do |s|
      h, m = s.split(':').map(&:to_i)
      60 * h + m
    end
    a = time1.divmod(60)
    calculated_time = a.join(':')
    total_time = calculated_time.to_time
    max_time = '12:00'
    time_limit = max_time.to_time
    return true if date1.present? && (total_time > time_limit)
  end

  def self.validate_update_time_sheet_time(time_sheet, _time_sheet_params, current_user, params)
    @time_sheet = time_sheet
    date2 = @time_sheet.date
    @time_sheets = current_user.time_sheets.where(date: date2).where.not(id: @time_sheet.id)
    timesheet_time = []
    a = params[:time_sheet]['time(4i)']
    b = params[:time_sheet]['time(5i)'].present? ? params[:time_sheet]['time(5i)'] : '00'
    c = "#{a}:#{b}"
    @time_sheets.each do |time_sheet|
      time = time_sheet.time.strftime('%H:%M')
      timesheet_time.push(time)
    end
    timesheet_time.push(c)
    time1 = timesheet_time.sum do |s|
      h, m = s.split(':').map(&:to_i)
      60 * h + m
    end
    a = time1.divmod(60)
    calculated_time = a.join(':')
    total_time = calculated_time.to_time
    max_time = '12:00'
    time_limit = max_time.to_time
    return true if date2.present? && (total_time > time_limit)
  end

  def self.check_date(get_date)
    if get_date != ''
      Date.parse(get_date)
    else
      Date.today
    end
  end

  def self.get_selected_date(day_name, get_date)
    day_date = check_date(get_date)
    if day_name
      if day_name == day_date.beginning_of_week.strftime('%A')
        day_date.beginning_of_week
      else
        day_date.next_week.beginning_of_week(day_name.to_sym.downcase)
      end
    else
      day_date
    end
  end
end
