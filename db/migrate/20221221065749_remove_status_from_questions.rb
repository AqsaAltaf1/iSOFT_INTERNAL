# frozen_string_literal: true

class RemoveStatusFromQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_column :questions, :status, :integer
  end
end
