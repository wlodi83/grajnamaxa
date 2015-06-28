class AddGameForeignKeyToComments < ActiveRecord::Migration
  def change
    add_column :comments, :game_id, :integer
    add_index :comments, :game_id
  end
end
