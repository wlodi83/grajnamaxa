class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :title
      t.text :description
      t.text :instruction
      t.text :source

      t.timestamps
    end
  end
end
