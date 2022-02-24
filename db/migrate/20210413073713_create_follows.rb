class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.integer :follower_id, null: false, foreign_key: true
      t.integer :followee_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
