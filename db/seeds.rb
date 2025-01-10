# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
def attach_avatar
  { io: File.open(
    Rails.root.join(
      'app', 'assets', 'images', 'ISOFTSTUDIOS.png'
    )
  ),
    filename: 'ISOFTSTUDIOS.png',
    content_type: 'image/png' }
end
unless Company.any?
  Company.find_or_create_by!([{
                    name: 'isoftstudios',
                    subdomain: 'isoftstudios.isoftinternal'
                  },
                   {
                     name: 'system',
                     subdomain: 'system.isoftinternal'
                   }])
end
@designation = UserDesignation.find_or_create_by!(name: "software_enginer",company_id: 1)
@designation1 = UserDesignation.find_or_create_by!(name: "hr",company_id: 2)
@role = Role.find_or_create_by!(name: 'ceo')
@department = Department.find_or_create_by!(name: "IT",company_id: 1)
@department2 = Department.find_or_create_by!(name: "IT",company_id: 2)
@location = Location.find_or_create_by!(work_location: "pak", country: "pakistan", state: "punjab", city: "lahore", company_id: 1, zip_code: "22444", address: "lahore johartown")
@location2 = Location.find_or_create_by!(work_location: "pak", country: "pakistan", state: "punjab", city: "lahore", company_id: 2, zip_code: "22444", address: "lahore johartown")
@shift = Shift.find_or_create_by!(name: "night shift", working_hours: 8, start_time: Time.now, end_time: Time.now+8, working_days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],company_id: 1)
@shift2 = Shift.find_or_create_by!(name: "night shift", working_hours: 8, start_time: Time.now, end_time: Time.now+8, working_days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],company_id: 2)
unless Admin.any?
  Admin.find_or_create_by!(user_email: 'hr@isoftstudios.com', joining_date: Date.today, company_id: 1)
  Admin.find_or_create_by!(user_email: 'superadmin@isoftstudios.com', joining_date: Date.today, company_id: 1)
  Admin.find_or_create_by!(user_email: 'employee@isoftstudios.com', joining_date: Date.today, company_id: 1)
  Admin.find_or_create_by!(user_email: 'hr@system.com', joining_date: Date.today, company_id: 2)
  Admin.find_or_create_by!(user_email: 'superadmin@system.com', joining_date: Date.today, company_id: 2)
  Admin.find_or_create_by!(user_email: 'employee@system.com', joining_date: Date.today, company_id: 2)
end
unless User.any?
  users_attributes = [{
                 first_name: "user111",
                 phone_number: "03184003196",
                 home_phone_no: "03184003196",
                 email: 'hr@isoftstudios.com',
                 password: 'Hrisoftstudios@_23',
                 user_type: 'user',
                 joining_date: Date.today,
                 avatar: attach_avatar,
                 company_id: 1,
                 role_id: @role.id,
                 department_id: @department.id,
                 location_id: @location.id,
                 shift_id: @shift.id,
                 hire_date: Date.today,
                 salary_type: "salary_based",
                 starting_date: Date.today,
                 user_designation_id: @designation.id
               },
                {
                  first_name: "user111",
                  phone_number: "03184003196",
                  home_phone_no: "03184003196",
                  email: 'superadmin@isoftstudios.com',
                  password: 'Password123$',
                  user_type: 'admin',
                  joining_date: Date.today,
                  avatar: attach_avatar,
                  company_id: 1,
                  role_id: @role.id,
                  department_id: @department.id,
                  location_id: @location.id,
                  shift_id: @shift.id,
                  hire_date: Date.today,
                  salary_type: "salary_based",
                  starting_date: Date.today,
                  user_designation_id: @designation.id
                },
                {
                  first_name: "user111",
                  phone_number: "03184003196",
                  home_phone_no: "03184003196",
                  email: 'employee@isoftstudios.com',
                  password: 'Password123$',
                  user_type: 'user',
                  joining_date: Date.today,
                  avatar: attach_avatar,
                  company_id: 1,
                  role_id: @role.id,
                  department_id: @department.id,
                  location_id: @location.id,
                  shift_id: @shift.id,
                  hire_date: Date.today,
                  salary_type: "salary_based",
                  starting_date: Date.today,
                  user_designation_id: @designation.id
                },
                {
                  first_name: "user111",
                  phone_number: "03184003196",
                  home_phone_no: "03184003196",
                  email: 'hr@system.com',
                  password: 'Password123$',
                  user_type: 'user',
                  joining_date: Date.today,
                  avatar: attach_avatar,
                  company_id: 2,
                  role_id: @role.id,
                  department_id: @department2.id,
                  location_id: @location2.id,
                  shift_id: @shift2.id,
                  hire_date: Date.today,
                  salary_type: "salary_based",
                  starting_date: Date.today,
                  user_designation_id: @designation1.id
                },
                {
                  first_name: "user111",
                  phone_number: "03184003196",
                  home_phone_no: "03184003196",
                  email: 'superadmin@system.com',
                  password: 'Password123$',
                  user_type: 'admin',
                  joining_date: Date.today,
                  avatar: attach_avatar,
                  company_id: 2,
                  role_id: @role.id,
                  department_id: @department2.id,
                  location_id: @location2.id,
                  shift_id: @shift2.id,
                  hire_date: Date.today,
                  salary_type: "salary_based",
                  starting_date: Date.today,
                  user_designation_id: @designation1.id
                },
                {
                  first_name: "user111",
                  phone_number: "03184003196",
                  home_phone_no: "03184003196",
                  email: 'employee@system.com',
                  password: 'Password123$',
                  user_type: 'user',
                  joining_date: Date.today,
                  avatar: attach_avatar,
                  company_id: 2,
                  role_id: @role.id,
                  department_id: @department2.id,
                  location_id: @location2.id,
                  shift_id: @shift2.id,
                  hire_date: Date.today,
                  salary_type: "salary_based",
                  starting_date: Date.today,
                  user_designation_id: @designation1.id
                }]
                users_attributes.each do |attributes|
                  User.find_or_create_by!(attributes)
                end
end
unless Project.any?
  projects_attributes = [
    { name: 'Isoft Internal', description: 'project1 description', active: true, company_id: 1 },
    { name: 'Production.com', description: 'project2 description', active: true, company_id: 1 },
    { name: 'Real Time Communication Features', description: 'project3 description', active: true, company_id: 1 }
  ]
  projects_attributes.each do |attributes|
    Project.find_or_create_by!(attributes)
  end
end
unless ApplyLeave.any?
  [
    { allowed_leave_type: 'casual', allowed_day: 15, company_id: 1 },
    { allowed_leave_type: 'short', allowed_hours: 10, company_id: 1 },
    { allowed_leave_type: 'sick', allowed_day: 20, company_id: 1 }
  ].each do |attributes|
    ApplyLeave.find_or_create_by!(attributes)
  end
end
unless Permission.any?
  Permission.create!([{
                       name: 'view_all_upcoming_holidays', controller: 'upcoming_holidays', description: 'can view all upcoming holidays', controller_method: 'index'
                     },
                      {
                        name: 'view_upcoming_holiday', controller: 'upcoming_holidays', description: 'can view upcoming holiday', controller_method: 'show'
                      },
                      {
                        name: 'create_upcoming_holiday', controller: 'upcoming_holidays', description: 'can create upcoming holiday', controller_method: 'create'
                      },
                      {
                        name: 'edit_upcoming_holiday', controller: 'upcoming_holidays', description: 'can edit upcoming holiday', controller_method: 'edit'
                      },
                      {
                        name: 'destroy_upcoming_holiday', controller: 'upcoming_holidays', description: 'can destroy upcoming holiday', controller_method: 'destroy'
                      },
                      {
                        name: 'view_all_time_sheets', controller: 'time_sheets', description: 'can view all time sheets', controller_method: 'index'
                      },
                      {
                        name: 'show_time_sheet', controller: 'time_sheets', description: 'can view time sheet', controller_method: 'show'
                      },
                      {
                        name: 'create_time_sheet', controller: 'time_sheets', description: 'can create time sheet', controller_method: 'create'
                      },
                      {
                        name: 'edit_time_sheet', controller: 'time_sheets', description: 'can  edit time sheet', controller_method: 'edit'
                      },
                      {
                        name: 'create_support', controller: 'supports', description: 'can create support', controller_method: 'create'
                      },
                      {
                        name: 'view_all_leaves', controller: 'leaves', description: 'can view all leaves', controller_method: 'index'
                      },
                      {
                        name: 'create_leave', controller: 'leaves', description: 'can create leave', controller_method: 'create'
                      },
                      {
                        name: 'view_all_evaluations', controller: 'evaluations', description: 'can view all evaluations', controller_method: 'index'
                      },
                      {
                        name: 'view_evaluation', controller: 'evaluations', description: 'can view evaluation', controller_method: 'show'
                      },
                      {
                        name: 'edit_evaluation', controller: 'evaluations', description: 'can edit evaluation', controller_method: 'edit'
                      },
                      {
                        name: 'create_evaluation', controller: 'evaluations', description: 'can create evaluation', controller_method: 'create'
                      },
                      {
                        name: 'employee_evaluation', controller: 'evaluations', description: 'can view employee evaluations', controller_method: 'employee_evaluation'
                      },
                      {
                        name: 'user_evaluation', controller: 'evaluations', description: 'can view user evaluations', controller_method: 'user_evaluation'
                      },
                      {
                        name: 'completed_evaluation', controller: 'evaluations', description: 'can view completed evaluation', controller_method: 'completed_evaluation'
                      },
                      {
                        name: 'view_all_company_assets', controller: 'company_assets', description: 'can view all company assets', controller_method: 'index'
                      },
                      {
                        name: 'edit_company_asset', controller: 'company_assets', description: 'can edit company asset', controller_method: 'edit'
                      },
                      {
                        name: 'create_company_asset', controller: 'company_assets', description: 'can create company asset', controller_method: 'create'
                      },
                      {
                        name: 'create_help_document', controller: 'help_documents', description: 'can create help document', controller_method: 'create'
                      },
                      {
                        name: 'edit_help_document', controller: 'help_documents', description: 'can edit help document', controller_method: 'edit'
                      },
                      {
                        name: 'destroy_help_document', controller: 'help_documents', description: 'can destroy help document', controller_method: 'destroy'
                      },
                      {
                        name: 'view_all_announcements', controller: 'announcements', controller_method: 'index', description: 'can view all announcements'
                      },
                      {
                        name: 'create_announcement', controller: 'announcements', controller_method: 'create', description: 'can create announcement'
                      },
                      {
                        name: 'update_announcement', controller: 'announcements', controller_method: 'update', description: 'can update announcement'
                      },
                      {
                        name: 'destroy_announcement', controller: 'announcements', controller_method: 'destroy', description: 'can destroy announcement'
                      },
                      {
                        name: 'create_user', controller: 'users', controller_method: 'create', description: 'can create user'
                      },
                      {
                        name: 'view_all_users', controller: 'users', controller_method: 'index', description: 'can view all users'
                      },
                      {
                        name: 'update_user', controller: 'users', controller_method: 'update', description: 'can update user'
                      },
                      {
                        name: 'destroy_user', controller: 'users', controller_method: 'destroy', description: 'can destroy user'
                      },
                      {
                        name: 'create_request', controller: 'requests', controller_method: 'create', description: 'can create request'
                      },
                      {
                        name: 'view_all_requests', controller: 'requests', controller_method: 'index', description: 'can view all requests'
                      },
                      {
                        name: 'update_request', controller: 'requests', controller_method: 'update', description: 'can update request'
                      },
                      {
                        name: 'destroy_request', controller: 'requests', controller_method: 'destroy', description: 'can destroy request'
                      }])
end