  class CategoriesController < ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy, :show]
  before_filter :authenticate_user!, except: [:show]
  before_action :is_admin, only: [:new, :create, :edit, :update, :destroy, :index]

  add_breadcrumb "Strona główna", :root_path

  def index
    @categories = Category.order(created_at: :desc).page(params[:page])
  end

  def show
    @games = @category.games.includes(:rating_average).where(published: true).order(created_at: :desc)
    add_breadcrumb @category.name
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_url, notice: "Kategoria zostala utworzona."
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to categories_url, notice: "Kategoria zostala poprawiona."
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: "Kategoria zostala usunieta."
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :short_name, :slug)
  end

  def is_admin
    current_user.admin?
  end
end
