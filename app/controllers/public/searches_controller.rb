class Public::SearchesController < ApplicationController
  def search
    @user = User.find(current_user.id)

    @model = params[:model]
    @word = params[:word]
    @method = params[:method]

    # 選択したモデルに応じて検索を実行
    if @model  == "user"
      @users = User.search_for(@word, @method).page(params[:page])
      if @users.count > 0
        flash.now[:notice] = "新しい仲間との出会いがここに！どんなトレーニングをしているか見てみましょう💪"
      else
        flash.now[:alert] = "該当するユーザーが見つかりませんでした💡 条件を変更してみてください！"
      end
      @current_participant = Participant.where(user_id: current_user.id)
      @users.each do |user|
        @another_participant = Participant.where(user_id: user.id)
        unless user.id == current_user.id
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
    else
      @posts = Post.search_for(@word, @method).order(created_at: :desc).page(params[:page])
      if @posts.count > 0
        flash.now[:notice] = "みんなのトレーニング記録を発見！インスピレーションを受け取ろう🔥！"
      else
        flash.now[:alert] = "まだ誰もそのトピックについて投稿していないようです。ぜひあなたが最初の投稿を🚀！"
      end
    end
  end
end