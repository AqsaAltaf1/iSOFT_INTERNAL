class RemoveUniqueIndexFromUsersMachineCode < ActiveRecord::Migration[7.0]
  def change
    remove_index :attendances, column: :user_machine_code
    remove_foreign_key :attendances, :users, column: :user_machine_code, primary_key: :machine_code, on_delete: :cascade
    remove_index :users, column: :machine_code
    add_index :users, :machine_code
  end
end
