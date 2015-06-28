class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  before_action :is_admin, only: [:admin, :destroy]

  add_breadcrumb "Strona główna", :root_path

  def admin
    @users = User.all.order(created_at: :desc).page(params[:page])
  end

  def index
    @users = User.all.order(created_at: :desc).page(params[:page])
    add_breadcrumb "Użytkownicy"
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'Użytkownik został usunięty'
  end

  def points
    @points = current_user.points
    add_breadcrumb "Punkty lojalnościowe"
  end

  private

  def is_admin
    current_user.admin?
  end
end
