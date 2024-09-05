class DropCommentsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :comments
  end

  def down
    create_table :comments do |t|
      t.text :body
      t.integer :user_id, null: false
      t.integer :task_id, null: false
      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :task_id
  end
end
