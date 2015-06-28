class AddPublishedAndPublishedAtColumnsToGames < ActiveRecord::Migration
  def change
    add_column :games, :published, :boolean
    add_column :games, :published_at, :datetime, null: true
  end
end