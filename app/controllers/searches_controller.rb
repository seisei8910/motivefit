class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @word = params[:word]
    @method = params[:method]

    # 選択したモデルに応じて検索を実行
    if @model  == "user"
      @users = User.search_for(@word, @method)
    else
      @books = Books.search_for(@word, @method)
    end
  end
end
