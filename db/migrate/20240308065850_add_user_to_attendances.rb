class AddUserToAttendances < ActiveRecord::Migration[7.0]
  def change
    # Add the slug column as a foreign key in the users table
    add_column :attendances, :user_machine_code, :string
    add_index :attendances, :user_machine_code
    # Add foreign key constraint
    add_foreign_key :attendances, :users, column: :user_machine_code, primary_key: :machine_code, on_delete: :cascade
  end
end
