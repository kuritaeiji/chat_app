class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.references :requesting_user, foreign_key: { to_table: :users }
      t.references :requested_user, foreign_key: { to_table: :users }
      t.boolean :approved, default: false
      t.timestamps
    end
  end
end
