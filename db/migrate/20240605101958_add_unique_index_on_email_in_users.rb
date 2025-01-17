class AddUniqueIndexOnEmailInUsers < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, name: "index_users_on_email"
    add_index :users, :email, unique: true, name: "index_users_on_email"
  end
end
