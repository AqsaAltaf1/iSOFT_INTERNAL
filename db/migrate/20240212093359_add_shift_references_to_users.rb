class AddShiftReferencesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :shift, null: true, foreign_key: true
  end
end
