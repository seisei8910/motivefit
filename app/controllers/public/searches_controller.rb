class Public::SearchesController < ApplicationController
  def search
    @user = User.find(current_user.id)
    @post = Post.new

    @model = params[:model]
    @word = params[:word]
    @method = params[:method]

    # 選択したモデルに応じて検索を実行
    if @model  == "user"
      @users = User.search_for(@word, @method)
      if @users.count > 0
        flash.now[:notice] = "新しい仲間との出会いがここに！どんなトレーニングをしているか見てみましょう💪"
      else
        flash.now[:alert] = "該当するユーザーが見つかりませんでした💡 条件を変更してみてください！"
      end
    else
      @posts = Post.search_for(@word, @method)
      if @posts.count > 0
        flash.now[:notice] = "みんなのトレーニング記録を発見！インスピレーションを受け取ろう🔥！"
      else
        flash.now[:alert] = "まだ誰もそのトピックについて投稿していないようです。ぜひあなたが最初の投稿を🚀！"
      end
    end
  end
end