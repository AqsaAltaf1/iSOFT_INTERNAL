# frozen_string_literal: true

class Leave < ApplicationRecord
  acts_as_paranoid
  acts_as_tenant :company
  belongs_to :user
  belongs_to :apply_leave
  enum :status, %i[pending approved rejected]
  enum :short_type, %i[first_half second_half]
  validate :dates_match_for_short_leave
  validate :hour_match_for_short_leave
  validates :from_time, presence: true,if: -> { apply_leave&.allowed_leave_type == 'short' }
  validates :to_time, presence: true,if: -> { apply_leave&.allowed_leave_type == 'short' }
  # validates :date_from, comparison: { less_than_or_equal_to: :date_to, greater_than_or_equal_to: Date.today }, if: proc { |a|
                                                                                                                  #    a.apply_leave&.allowed_leave_type != 'short'
                                                                                                                  #  }
  # validates :date_to, comparison: { greater_than_or_equal_to: Date.today }, if: proc { |a|
                                                                                #   a.apply_leave&.allowed_leave_type != 'short'
                                                                                # }
  validate :date_from_must_be_valid, if: :new_record_and_not_short_leave?
  validate :date_to_must_be_valid, if: :new_record_and_not_short_leave?                                                                              
  validates :date_from, :date_to, presence: true
  validates :short_type, absence: true, if: -> { apply_leave&.allowed_leave_type == 'short' }
  # validates :short_type, presence: true, if: -> { apply_leave&.allowed_leave_type == 'short' }
  # validates :hours, numericality: { in: 2..6 }, presence: true,if: -> { apply_leave&.allowed_leave_type == 'short' }
  scope :today, -> { where(created_at: (Time.now.beginning_of_day..Time.now.end_of_day)) }
  scope :selected_leaves, ->(status) { where(status:) }
  scope :leaves_for_leave_type, lambda { |user_id, status, leave_type|
                                  where(user_id:).where(status:).where(apply_leave_id: leave_type)
                                }
  scope :selected_type, ->(type) { where(apply_leave_id: type) }
  has_rich_text :body
  has_many :notes, as: :notable, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'
  has_many_attached :files
  validates :files, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

  def dates_match_for_short_leave
    if (apply_leave&.allowed_leave_type == 'short' || short_type.present?) && date_to != date_from
      errors.add(:date_to, 'and Date From must be the same for half leave.')
    end
  end

  def is_type_short?
    apply_leave&.allowed_leave_type == "short"
  end

  has_noticed_notifications model_name: 'Notification'

  def leave_type_normal
    @user_leaves = Leave.leaves_for_leave_type(user_id, 'approved', apply_leave_id)
    @apply_leave_type = ApplyLeave.find(apply_leave_id).allowed_leave_type
    if date_to.present? && date_from.present?
      days = (date_to.to_datetime - date_from.to_datetime).to_i
      @apply_leave_type == "short" ? leave_type_short_logic(@user_leaves) : leave_type_normal_logic(@user_leaves)
    else
      true
    end
  end

  def leave_type_short_logic(user_leaves)
    user_leaves&.sum(:hours) + self.hours <= apply_leave&.allowed_hours  
  end

  def leave_type_normal_logic(user_leaves)
    total_leaves = user_leaves&.sum(:request_leaves)
    days = (date_to.to_datetime - date_from.to_datetime).to_i
    days += short_type&.present? ? 0.5 : 1
    if total_leaves + days > apply_leave&.allowed_day
      false
    else
      self.request_leaves = days
      true
    end
  end

  def calculate_hours(from_time, to_time)
    from_time = from_time.to_time
    to_time = to_time.to_time
    difference_in_seconds = (from_time - to_time).abs
    difference_in_hours = difference_in_seconds / 3600.0
    difference_in_hours
  end

  def hour_match_for_short_leave
    if (apply_leave&.allowed_leave_type == 'short' || short_type.present?) && from_time.present? && to_time.present?
      expected_hours = hours
      actual_hours = calculate_hours(from_time, to_time)
      if actual_hours != expected_hours
        errors.add(:base, 'The duration between Date From and Date To must match the allowed hours for a short leave.')
      end
    end
  end

  def new_record_and_not_short_leave?
    new_record? && apply_leave&.allowed_leave_type != 'short'
  end

  def date_from_must_be_valid
    if date_from.present? && (date_from > date_to || date_from < Date.today)
      errors.add(:date_from, 'must be less than or equal to date_to and greater than or equal to today')
    end
  end

  def date_to_must_be_valid
    if date_to.present? && date_to < Date.today
      errors.add(:date_to, 'must be greater than or equal to today')
    end
  end
end
