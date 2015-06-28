class AddIsMobileToGames < ActiveRecord::Migration
  def change
    add_column :games, :is_mobile, :boolean, default: false
    add_column :games, :apple_store_url, :string
    add_column :games, :google_play_url, :string
  end
end
