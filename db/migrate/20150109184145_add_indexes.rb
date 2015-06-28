class AddIndexes < ActiveRecord::Migration
  def change
    add_index :games, :title
    add_index :categories, :name
  end
end
