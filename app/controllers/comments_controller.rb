class CommentsController < ApplicationController
  before_action :set_game, only: [:new, :create]
  before_filter :authenticate_user!, except: [:new, :create]
  before_action :is_admin, only: [:destroy, :index]

  def index
    @comments = Comment.includes(:game).order(created_at: :desc).page(params[:page])
  end

  def new
    @comment = @game.comments.new(parent_id: params[:parent_id])
  end

  def create
    if params[:comment][:parent_id].to_i > 0
      parent = Comment.find_by_id(params[:comment].delete(:parent_id))
      @comment = parent.children.new(comment_params)
      @comment.game_id = @game.id
    else
      @comment = @game.comments.new(comment_params)
    end

    @comment.author = current_user.username if current_user
    @comment.user_id = current_user.id if current_user

    if verify_recaptcha(model: @comment, message: 'Nieprawidłowy kod weryfikacyjny captcha') && @comment.save
      flash[:success] = 'Twój komentarz został dodany!'
      redirect_to game_url(@game)
    else
      render 'new'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    user = User.where(id: @comment.user_id).first
    #remove 10 points from user account
    Merit::Sash.find(user.sash_id).add_points -10 if !user.nil?
    @comment.destroy
    redirect_to comments_url, notice: 'Komentarz został usunięty'
  end

  private

  def set_game
    @game = Game.friendly.find(params[:game_id])
  end

  def comment_params
    params.require(:comment).permit(:title, :body, :author, :game_id)
  end

  def is_admin
    current_user.admin?
  end
end
