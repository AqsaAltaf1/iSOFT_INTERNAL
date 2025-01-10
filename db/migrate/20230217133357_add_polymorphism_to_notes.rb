# frozen_string_literal: true

class AddPolymorphismToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :notable_type, :string
    add_column :notes, :notable_id, :integer
  end
end
