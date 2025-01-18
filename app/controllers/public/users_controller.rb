class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def mypage
    @user = User.find(current_user.id)
    @post = Post.new
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールを更新しました！新しいあなたのスタートです 🚀"
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "退会が完了しました。これまでモチベフィットをご利用いただきありがとうございました 🙏✨ またいつでもお待ちしています！"
    redirect_to new_user_registration_path
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @posts = @user.posts.order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :status_message)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to mypage_path
    end
  end
end
