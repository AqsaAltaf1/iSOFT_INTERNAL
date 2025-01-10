class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.integer :payment_method
      t.string :bank_name
      t.string :branch_name
      t.string :branch_code
      t.string :account_number
      t.string :bank_code
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.timestamps
    end
  end
end
