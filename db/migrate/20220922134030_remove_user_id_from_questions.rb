# frozen_string_literal: true

class RemoveUserIdFromQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_reference :questions, :user, null: false, foreign_key: true
    remove_column :questions, :user_type, :integer
  end
end
