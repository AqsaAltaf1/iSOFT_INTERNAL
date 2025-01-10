# frozen_string_literal: true

class AddCompanyReferenceToRequiredModels < ActiveRecord::Migration[7.0]
  def change
    add_reference :addresses, :company, null: true, foreign_key: true
    add_reference :announcements, :company, null: true, foreign_key: true
    add_reference :apply_leaves, :company, null: true, foreign_key: true
    add_reference :assigned_users, :company, null: true, foreign_key: true
    add_reference :attachments, :company, null: true, foreign_key: true
    add_reference :company_assets, :company, null: true, foreign_key: true
    add_reference :evaluation_feed_backs, :company, null: true, foreign_key: true
    add_reference :evaluation_options, :company, null: true, foreign_key: true
    add_reference :evaluations, :company, null: true, foreign_key: true
    add_reference :leaves, :company, null: true, foreign_key: true
    add_reference :notes, :company, null: true, foreign_key: true
    add_reference :notifications, :company, null: true, foreign_key: true
    add_reference :projects, :company, null: true, foreign_key: true
    add_reference :questions, :company, null: true, foreign_key: true
    add_reference :time_sheets, :company, null: true, foreign_key: true
    add_reference :user_projects, :company, null: true, foreign_key: true
    add_reference :users, :company, null: true, foreign_key: true
    add_reference :admins, :company, null: true, foreign_key: true
  end
end
