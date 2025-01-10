# frozen_string_literal: true

class CreateSupports < ActiveRecord::Migration[7.0]
  def change
    create_table :supports do |t|
      t.string :subject
      t.string :email
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
