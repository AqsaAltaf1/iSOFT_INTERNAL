class AddNewFieldsInUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :father_name, :string
    add_column :users, :mother_name, :string
    add_column :users, :blood_group, :integer, null: true
    add_column :users, :qualification, :integer, null: true
    add_column :users, :martial_status, :integer, null: true
    add_column :users, :date_of_birth, :date
    add_column :users, :religion, :integer, null: true
    add_column :users, :cnic_number, :string
    add_column :users, :passport_number, :string
    add_column :users, :home_phone_no, :string
    add_column :users, :emergency_contact_name, :string
    add_column :users, :emergency_contact_phone_no, :string
    add_column :users, :probation_end_date, :date
    add_column :users, :hire_date, :date
    add_column :users, :gender, :integer, null: true
    add_column :users, :eobi_number, :string
    add_column :users, :ntn_number, :string
    add_column :users, :salary_type, :integer, null: true
    add_column :users, :base_salary, :string
    add_column :users, :starting_date, :date
  end
end
