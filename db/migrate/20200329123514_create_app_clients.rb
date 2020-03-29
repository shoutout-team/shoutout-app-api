class CreateAppClients < ActiveRecord::Migration[6.0]
  def change
    create_table :app_clients do |t|
      t.string :name, null: false
      t.integer :kind, null: false, default: 0
      t.string :api_key, null: false
      t.string :host
      t.integer :user_id
      t.boolean :approved, null: false, default: false
      t.boolean :active, null: false, default: false
      t.jsonb :properties, null: false, default: {}

      t.timestamps
    end

    add_index :app_clients, :api_key, unique: true
    add_index :app_clients, :user_id
    add_index :app_clients, :approved
    add_index :app_clients, :active
    add_index :app_clients, :properties, using: :gin
  end
end
