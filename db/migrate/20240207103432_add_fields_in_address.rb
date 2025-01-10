class AddFieldsInAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :temporary_address, :string
    add_column :addresses, :permanent_address, :string
  end
end
