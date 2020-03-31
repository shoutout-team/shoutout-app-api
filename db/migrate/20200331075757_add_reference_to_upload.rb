class AddReferenceToUpload < ActiveRecord::Migration[6.0]
  def change
    add_column :uploads, :reference, :string, null: false
  end
end
