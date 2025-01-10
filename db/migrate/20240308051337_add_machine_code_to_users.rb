class AddMachineCodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :machine_code, :string
    add_index :users, :machine_code, unique: true
  end
end
