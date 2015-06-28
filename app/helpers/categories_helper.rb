module CategoriesHelper
  def category_games(category)
    Game.last_3_games(category).to_sentence
  end
end
