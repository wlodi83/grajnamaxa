class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy, :publish, :unpublish]
  before_filter :authenticate_user!, except: [:show, :index, :search]
  before_action :is_admin, only: [:new, :create, :admin, :edit, :update, :destroy, :publish, :unpublish]

  add_breadcrumb "Strona główna", :root_path

  def admin
    @games = Game.all.order(created_at: :desc).page(params[:page])
  end

  def search
    @games = Game.includes(:category).search(params[:query]).order(created_at: :desc).page params[:page]
    add_breadcrumb "Szukaj"
  end

  def publish
    @game.update(published: true)
    @game.touch(:updated_at, :published_at)
    redirect_to admin_games_url
  end

  def unpublish
    @game.update(published: false, published_at: nil)
    @game.touch(:updated_at)
    redirect_to admin_games_url
  end

  def index
    case
    when params[:tag]
      @games = Game.published.tagged_with(params[:tag])
      add_breadcrumb params[:tag]
    when params[:param] == 'new_games'
      @page_header = "Najnowsze gry"
      @games = Game.published.limit(25)
      add_breadcrumb "Najnowsze gry"
    when params[:param] == 'best_games'
      @page_header = "Najlepsze gry"
      @games = Game.best_games_all.limit(25)
      add_breadcrumb "Najlepsze gry"
    when params[:param] == 'mobile'
      @page_header = "Gry mobilne"
      @games = Game.where(is_mobile: true)
      add_breadcrumb "Gry mobilne"
    else
      @page_header = "Wszystkie gry"
      @games = Game.published
      add_breadcrumb "Wszystkie gry"
    end
  end

  def show
    @comments = Comment.includes(:user, :children).where(game_id: @game).hash_tree
    add_breadcrumb @game.title
  end

  def new
    @game = Game.new
  end

  def edit
  end

  def create
    @game = Game.new(game_params)
    @game.user_id = current_user.id if current_user

    if @game.save
      redirect_to admin_games_url, notice: 'Gra została utworzona.'
    else
      render :new
    end
  end

  def update
    if @game.update(game_params)
      redirect_to admin_games_url, notice: 'Gra została poprawiona.'
    else
      render :edit
    end
  end

  def destroy
    @game.destroy
    redirect_to admin_games_url, notice: 'Gra została usunięta.'
  end

  private
  
  def set_game
    @game = Game.friendly.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:title, :description, :instruction, :source, :category_id, :screen, :user_id, :tag_list, :slug, :developer_name, :provider, :is_mobile, :apple_store_url, :google_play_url, :has_youtube, :youtube_url)
  end

  def is_admin
    current_user.admin?
  end
end