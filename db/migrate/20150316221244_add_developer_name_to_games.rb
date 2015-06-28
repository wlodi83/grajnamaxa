class AddDeveloperNameToGames < ActiveRecord::Migration
  def change
    add_column :games, :developer_name, :string
  end
end
