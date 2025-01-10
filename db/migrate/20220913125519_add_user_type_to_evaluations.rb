# frozen_string_literal: true

class AddUserTypeToEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :user_type, :integer
  end
end
