class AddYoutubeLinkToGames < ActiveRecord::Migration
  def change
    add_column :games, :has_youtube, :boolean, default: false
    add_column :games, :youtube_url, :string
  end
end
