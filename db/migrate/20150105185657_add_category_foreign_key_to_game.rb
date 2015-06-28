class AddCategoryForeignKeyToGame < ActiveRecord::Migration
  def change
    add_column :games, :category_id, :integer
    add_index :games, :category_id
  end
end
