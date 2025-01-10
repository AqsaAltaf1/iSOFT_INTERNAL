class CreateTimePolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :time_policies do |t|
      t.json :missing_attendance
      t.json :late_arrival
      t.json :early_out
      t.json :hours_per_day
      t.json :missing_swipe
      t.json :overtime_policy
      t.references :employee_group, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
