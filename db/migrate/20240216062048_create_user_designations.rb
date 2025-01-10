class CreateUserDesignations < ActiveRecord::Migration[7.0]
  def change
    create_table :user_designations do |t|
      t.string :name
      t.references :company, null: true, foreign_key: true

      t.timestamps
    end
  end
end
