class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :postcode, null: false
      t.string :federate_state, null: false
      t.integer :osm_id, null: false

      t.timestamps
    end

    add_index :locations, :name
    add_index :locations, :postcode
    add_index :locations, :federate_state
    add_index :locations, :osm_id
  end
end
