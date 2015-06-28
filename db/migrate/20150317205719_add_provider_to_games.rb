class AddProviderToGames < ActiveRecord::Migration
  def change
    add_column :games, :provider, :string
  end
end
