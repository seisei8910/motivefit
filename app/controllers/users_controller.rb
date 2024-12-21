class UsersController < ApplicationController
  def mypage
    @user = User.find(current_user.id)
    @posts = @user.posts
  end

  def edit
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :status_message)
  end
end
