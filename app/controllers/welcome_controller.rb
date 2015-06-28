class WelcomeController < ApplicationController
  #caches_page :index, :terms_of_use, :privacy_policy, :about, :contact, :for_parents
  layout 'application'

  add_breadcrumb "Strona główna", :root_path

  def index
    @new_games = Game.new_games
    @best_games = Game.best_games.limit(5)
    @popular_games = Game.popular_games
    @recent_users = User.recent_users
    @last_comments = Comment.last_5_comments
  end

  def terms_of_use
    add_breadcrumb "Warunki korzystania z witryny"
  end

  def privacy_policy
    add_breadcrumb "Polityka prywatności"
  end

  def about
    add_breadcrumb "O nas"
  end

  def contact
    add_breadcrumb "Pomoc i kontakt"
  end

  def for_parents
    add_breadcrumb "Informacje dla rodziców"
  end
end