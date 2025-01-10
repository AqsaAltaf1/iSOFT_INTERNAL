# app/models/user.rb
# frozen_string_literal: true

# user's model
class User < ApplicationRecord
  acts_as_paranoid
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable
  enum :allow_leave_approval, %i[no yes]
  enum :user_type, %i[user super_admin admin]
  enum :status, %i[pending inactive active]
  enum :blood_group, %i[A+ A- B+ B- AB+ AB- O- O+]
  enum :martial_status, %i[single married divorced/widdow N/A]
  enum :qualification, %i[masters bachelors intermediate matric]
  enum :religion, %i[muslim christian hindu non-muslim]
  enum :gender, %i[male female others]
  enum :salary_type, %i[salary_based hourly_based]
  enum :employment_type, %i[full_time remote part_time probation permanent(confirmed) permanent(probation) extended_probation retirement internship overtime daily_wages contract director(owner)]
  belongs_to :role
  belongs_to :user_designation
  belongs_to :department
  belongs_to :location
  belongs_to :shift
  has_many :permissions, through: :role
  after_initialize :set_default_user_type, if: :new_record?
  def set_default_user_type
    self.user_type ||= :user
  end
  scope :all_hrs, -> { includes(:role).where('roles.name ILIKE ?', '%hr%').references(:roles) }
  scope :employees_that_are_not_hrs, -> { where(user_type: 'user').where.not(id: all_hrs) }
  scope :all_users, -> { where(user_type: 'user') }
  def generate_remember_token
    SecureRandom.urlsafe_base64
  end
  has_many :subordinates, class_name: 'User',
                          foreign_key: 'report_to_id'
  has_many :attendances,  dependent: :destroy,
                          primary_key: 'machine_code', foreign_key: 'user_machine_code'
  belongs_to :report_to, class_name: 'User', optional: true
  acts_as_tenant :company
  has_many :histories, dependent: :destroy
  has_many :company_assets, through: :histories
  has_many :user_projects, dependent: :destroy
  has_many :supports, dependent: :destroy
  # has_many :evaluation_feed_backs, dependent: :destroy
  # has_many :evaluations, through: :evaluation_feed_backs
  has_many :assigned_users, dependent: :destroy
  has_many :evaluations, through: :assigned_users, dependent: :destroy
  has_many :leaves, dependent: :destroy
  has_many :projects, through: :user_projects, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :time_sheets, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  has_one_attached :avatar, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_one :address, dependent: :destroy
  has_one :payment, dependent: :destroy
  # after_commit :add_default_avatar, on: %i[create update]
  has_many :notes, dependent: :destroy
  after_commit :send_email, on: :create
  # validate :joining_date_cannot_be_in_the_past, on: %i[create]
  validates :role_id, :hire_date, :salary_type, :starting_date, presence: true, on: %i[create]
  validate :custom_avatar_validation
  validate :password_complexity
  # validate :phone_number_complexity, on: %i[create, edit,update]
  validates :joining_date, comparison: { greater_than_or_equal_to: :hire_date }
  validate :age_above_18
  validates :machine_code, uniqueness: { scope: :company_id }
  # validate :check_associated_attendances, on: :update
  validates :phone_number, :home_phone_no, format: {
    with: /^((\+92)?(0092)?(92)?(0)?)(3)([0-9]{2})((-?)|( ?))([0-9]{7})$/,
    message: 'is not valid', multiline: true
  }, on: %i[create update]
  validates :first_name, format: {
    with: /\A[^0-9\W].*\z/, message: ' is not valid.'
  }, on: %i[create update]
  # validates :phone_number, numericality: { only_integer: true }, on: %i[create update]
  has_noticed_notifications model_name: 'Notification'
  scope :get_attachment_owner_name, lambda { |attachment_id|
    joins(:attachments).where(attachments: { id: attachment_id }).pluck(:first_name, :last_name).join(' ')
  }

  scope :searched_users, lambda { |search_word|
                           where('first_name ILIKE ? OR last_name ILIKE ?', "%#{search_word}%", "%#{search_word}%")
                         }

  accepts_nested_attributes_for :address, :allow_destroy => true
  accepts_nested_attributes_for :payment
  # has_one :address, dependent: :destroy, inverse_of: :user, autosave: true
  # Class level accessor http://apidock.com/rails/Class/cattr_accessor
  cattr_accessor :form_steps do
    %w[sign_up set_address]
  end

  def age_above_18
    if date_of_birth.present? && date_of_birth > 18.years.ago.to_date
      errors.add(:date_of_birth, 'must be at least 18 years ago')
    end
  end

  def is_hr
    role&.name&.downcase&.match?(/human|hr|human\s*resource|human_resource/)
  end

  def active_for_authentication?
    super && active? # i.e. super && self.is_active
  end

  def inactive_message
    'Sorry, this account has been deactivated.'
  end

  # methods for forgot_password_api {generate_password_token , password_token_valid , reset_password , generate_token}
  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
    UserMailer.password_reset(self).deliver_now
  end

  def self.all_user_types
    user_types.keys.map { |key| [key.titleize, key] }
  end

  def self.all_employment_types
    employment_types.keys.map { |employment_type| [employment_type.humanize, employment_type] }
  end

  def self.all_leave_approvals
    allow_leave_approvals.keys.map { |approval| [approval.titleize, approval] }
  end

  def self.all_blood_groupes
    blood_groups.keys.map { |blood_group| [blood_group.humanize, blood_group] }
  end

  def self.all_martial_statuses
    martial_statuses.keys.map { |martial_status| [martial_status.humanize, martial_status] }
  end
   
  def self.all_qualifications
    qualifications.keys.map { |qualification| [qualification.humanize, qualification] }
  end

  def self.all_religions
    religions.keys.map { |religion| [religion.humanize, religion] }
  end

  def self.all_genders
    genders.keys.map { |gender| [gender.humanize, gender] }
  end

  def self.all_salary_types
    salary_types.keys.map { |salary_type| [salary_type.humanize, salary_type] }
  end

  def password_required? = false

  def joining_date_cannot_be_in_the_past
    errors.add(:joining_date, "can't be in the past") if joining_date.present? && joining_date < Date.today
  end

  def send_email
    SendUserEmailJob.perform_now(self)
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])/

    errors.add :password, 'Complexity requirement not met. Please use: 1 uppercase, 1 lowercase and 1 digit'
  end

  # def phone_number_complexity
  #   return if phone_number.blank? || phone_number =~ /^((\+92)?(0092)?(92)?(0)?)(3)([0-9]{2})((-?)|( ?))([0-9]{7})$/
  #   errors.add :phone_number, 'Complexity requirement not met. Note: Only Pakistan number is supported'
  # end

  def password_token_valid?
    (reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def custom_avatar_validation
    errors.add(:avatar, 'must be a valid image format (PNG, JPG, JPEG)') if avatar.attached? && !avatar_is_valid?
  end

  def avatar_is_valid?
    valid_formats = ['image/png', 'image/jpg', 'image/jpeg']
    avatar_blob = avatar.blob
    valid_formats.include?(avatar_blob.content_type)
  end

  # Instance level accessor http://apidock.com/ruby/Module/attr_accessor
  attr_accessor :form_step

  def form_step
    @form_step ||= 'sign_up'
  end

  # validates_associated :address, if: -> { required_for_step?('set_address') }

  def full_name
    "#{first_name&.capitalize} #{last_name&.capitalize}"
  end

  def display_name
    full_name.presence || email
  end

  # accepts_nested_attributes_for :address, allow_destroy: true

  def required_for_step?(step)
    # All fields are required if no form step is present
    form_step.nil?

    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    form_steps.index(step.to_s) <= form_steps.index(form_step.to_s)
  end

  def avatar_thumbnail
    Cloudinary::Utils.private_download_url(avatar.key, 'jpg')
  end

  scope :contact_list_present, -> { where(can_contact: true) }

  private

  def generate_token
    SecureRandom.hex(10)
  end

  def check_associated_attendances
    if Attendance.where(user_machine_code: machine_code_was).any?
      errors.add(:machine_code, "cannot be updated because associated attendances exist.")
    end
  end

  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            'app', 'assets', 'images', 'ISOFTSTUDIOS.png'
          )
        ),
        filename: 'ISOFTSTUDIOS.png',
        content_type: 'image/png'
      )
    end
  end
end
