# frozen_string_literal: true

class AddJoiningDateToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :joining_date, :date
  end
end
