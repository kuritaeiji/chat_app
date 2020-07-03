class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest
      t.text :description
      t.string :identifier_id, null: false
      t.timestamps
    end
    add_index :users, :email
  end
end