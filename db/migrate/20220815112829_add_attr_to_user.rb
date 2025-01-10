# frozen_string_literal: true

class AddAttrToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :can_contact, :boolean, default: false
    # Ex:- :default =>''
    # Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
