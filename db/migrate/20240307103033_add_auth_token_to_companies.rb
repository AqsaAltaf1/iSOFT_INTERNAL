class AddAuthTokenToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :auth_token, :string
  end
end
