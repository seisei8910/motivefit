class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @user = User.find(current_user.id)
    @post = Post.new

    @model = params[:model]
    @word = params[:word]
    @method = params[:method]

    # 選択したモデルに応じて検索を実行
    if @model  == "user"
      @users = User.search_for(@word, @method)
    else
      @posts = Post.search_for(@word, @method)
    end
  end
end