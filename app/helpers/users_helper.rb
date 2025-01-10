# frozen_string_literal: true

module UsersHelper
  def get_role
    Role.get_all_roles(current_user.company.id)
  end

  def get_designation
    UserDesignation.get_all_designations(current_user.company.id)
  end

  def get_location
    Location.get_all_locations(current_user.company.id)
  end

  def get_shift
    Shift.get_all_shifts(current_user.company.id)
  end

  def get_department
    Department.get_all_departments(current_user.company.id)
  end

  def get_user_type
    User.all_user_types
  end

  def get_employment_type
    User.all_employment_types
  end
  
  def get_blood_groups
    User.all_blood_groupes
  end

  def get_martial_status
    User.all_martial_statuses
  end

  def get_religion
    User.all_religions
  end

  def get_qualification
    User.all_qualifications
  end

  def get_gender
    User.all_genders
  end

  def get_salary_type
    User.all_salary_types
  end

  def get_leave_approval
    User.all_leave_approvals
  end

  def get_all_users
    User.all_users
  end
end
