class Public::PostsController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def new
    @post = Post.new(start_time: params[:date])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "投稿完了！あなたの努力がみんなのモチベーションに繋がります 🌟"
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = "投稿を削除しました！次の記録でまた頑張りましょう 💪✨"
    redirect_to posts_path
  end

  def index
    @user = current_user
    @posts = Post.all.order(created_at: :desc).page(params[:page]).per(4)
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      sleep(3)
      flash[:notice] = "投稿を更新しました！新しい内容でモチベーションアップ 💪🔥"
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def follow_feed
    @users = current_user.followings.page(params[:page]).per(8)
    @user = current_user
    @posts = Post.where(user_id: [current_user.id, *current_user.following_ids]).order(created_at: :desc).page(params[:page]).per(4)
  end

  private
    def post_params
      params.require(:post).permit(:start_time, :title, :menu, :body, :image)
    end

    def is_matching_login_user
      post = Post.find(params[:id])
      unless post.user.id == current_user.id
        redirect_to posts_path
      end
    end
end
