class AddUserToGames < ActiveRecord::Migration
  def change
    add_reference :games, :user, index: true
    add_foreign_key :games, :users
  end
end
