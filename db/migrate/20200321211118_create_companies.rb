class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.integer :category, null: false
      t.string :slug, null: false
      t.string :postcode, null: false
      t.string :city, null: false
      t.string :street, null: false
      t.string :street_number, null: false
      t.text :description
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.jsonb :properties, null: false, default: {}
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index :companies, :name
    add_index :companies, :category
    add_index :companies, :slug
    add_index :companies, :latitude
    add_index :companies, :longitude
    add_index :companies, :properties, using: :gin
    add_index :companies, :user_id
  end
end
