class AddDeveloperKeyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :developer_key, :string
    add_index :users, :developer_key
  end
end
