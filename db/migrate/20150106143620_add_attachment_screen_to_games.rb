class AddAttachmentScreenToGames < ActiveRecord::Migration
  def self.up
    change_table :games do |t|
      t.attachment :screen
    end
  end

  def self.down
    remove_attachment :games, :screen
  end
end