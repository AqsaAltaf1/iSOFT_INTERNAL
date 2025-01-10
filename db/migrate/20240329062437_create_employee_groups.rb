class CreateEmployeeGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_groups do |t|
      t.bigint :code
      t.string :name
      t.text :description
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
