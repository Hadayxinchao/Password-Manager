class CreatePasswordEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :password_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :website_url, null: false
      t.text :encrypted_username
      t.text :encrypted_password
      t.text :encrypted_notes
      t.boolean :favorite, default: false

      t.timestamps
    end

    add_index :password_entries, [ :user_id, :title ]
    add_index :password_entries, :website_url
  end
end
