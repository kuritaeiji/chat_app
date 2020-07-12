class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.datetime :last_read_time, default: Time.zone.now
      t.timestamps
    end
  end
end
