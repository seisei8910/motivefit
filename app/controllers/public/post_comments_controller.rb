class Public::PostCommentsController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = post.id
    if comment.save
      flash[:notice] = "コメントを投稿しました！💬✨"
      redirect_to post_path(post)
    else
      flash.now[:alert] = "コメントの投稿に失敗しました💦 もう一度お試しください。"
      @post = Post.find(params[:post_id])
      @post_comment = PostComment.new
      render "public/posts/show"
    end
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private
    def post_comment_params
      params.require(:post_comment).permit(:comment)
    end
end
