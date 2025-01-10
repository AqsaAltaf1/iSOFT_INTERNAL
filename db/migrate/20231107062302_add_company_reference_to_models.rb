# frozen_string_literal: true

class AddCompanyReferenceToModels < ActiveRecord::Migration[7.0]
  def change
    add_reference :histories, :company, null: true, foreign_key: true
    add_reference :upcoming_holidays, :company, null: true, foreign_key: true
    add_reference :supports, :company, null: true, foreign_key: true
    add_reference :help_documents, :company, null: true, foreign_key: true
  end
end
