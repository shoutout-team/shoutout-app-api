class AddApprovedToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :approved, :boolean, null: false, default: false
    add_index :companies, :approved
  end
end
