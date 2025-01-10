class AddDepartmentToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :department, null: true, foreign_key: true
    add_reference :departments, :company, null: true, foreign_key: true
  end
end
