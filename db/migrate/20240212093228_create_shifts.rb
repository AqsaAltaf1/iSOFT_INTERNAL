class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.string :name
      t.integer :working_hours
      t.datetime :start_time
      t.datetime :end_time
      t.text :working_days
      t.references :company, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
