class AddGidToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :gid, :string, null: false
    add_index :companies, :gid, unique: true
  end
end
