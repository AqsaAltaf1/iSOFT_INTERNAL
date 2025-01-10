class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :work_location
      t.string :country
      t.string :state
      t.string :city
      t.string :zip_code
      t.text :address
      t.references :company, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
