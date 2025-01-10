class AddLastSyncAtToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :last_sync_at, :datetime
  end
end
