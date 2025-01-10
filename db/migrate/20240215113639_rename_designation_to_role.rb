class RenameDesignationToRole < ActiveRecord::Migration[7.0]
  def self.up
    rename_table :designations, :roles
    rename_table :designations_permissions, :roles_permissions
    rename_column :roles_permissions, :designation_id, :role_id
    rename_column :users, :designation_id, :role_id
  end
  def self.down
    rename_table :roles, :designations
    rename_table :roles_permissions, :designations_permissions
    rename_column :designations_permissions, :role_id, :designation_id
    rename_column :users, :role_id, :designation_id
  end
end
