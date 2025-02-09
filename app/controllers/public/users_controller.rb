class Public::UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit]

  def mypage
    @user = User.find(current_user.id)
    @post = Post.new
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(4)
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
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(4)
    @current_participant = Participant.where(user_id: current_user.id)
    @another_participant = Participant.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_participant.each do |current|
        @another_participant.each do |another|
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @participant = Participant.new
      end
    end
  end

  def favorite_posts
    @user = User.find(current_user.id)
    @post = Post.new
    favorites = Favorite.where(user_id: @user).pluck(:post_id)
    @favorite_posts = Post.where(id: favorites).order(created_at: :desc).page(params[:page]).per(4)
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

  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.guest_user?
      redirect_to user_path(current_user) , notice: "ゲストユーザーはプロフィール編集画面へ遷移できません。"
    end
  end
end
