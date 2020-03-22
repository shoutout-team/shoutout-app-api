class RenameTokenToGidOnUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :token, :gid
  end
end
