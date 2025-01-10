class AddUserDesignationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :user_designation, null: true, foreign_key: true
  end
end
