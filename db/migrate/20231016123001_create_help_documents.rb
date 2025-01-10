# frozen_string_literal: true

class CreateHelpDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :help_documents do |t|
      t.string :name

      t.timestamps
    end
  end
end
