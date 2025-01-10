class AddCloumnToEmployeeGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :employee_groups, :employee, :text
  end
end
