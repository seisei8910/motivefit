class Admin::UsersController < ApplicationController
  layout "admin"

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(4)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_dashboards_path, notice: "ユーザーを削除しました。"
  end
end
