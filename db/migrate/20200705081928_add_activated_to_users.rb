class AddActivatedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :activated, :boolean
    add_column :users, :activated_at, :datetime
    add_column :users, :activation_digest, :string
  end
end
