class CreateUploads < ActiveRecord::Migration[6.0]
  def change
    create_table :uploads do |t|
      t.string :entity, null: false
      t.string :kind, null: false
      t.string :key

      t.timestamps
    end

    add_index :uploads, :key
  end
end
