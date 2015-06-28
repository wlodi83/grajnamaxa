class AddUserForeignKeyToComment < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer, null: true
    add_index :comments, :user_id
  end
end
