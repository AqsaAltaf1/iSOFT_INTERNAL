# frozen_string_literal: true

class AddPhoneNoAttributeToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :phone_number, :string
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
