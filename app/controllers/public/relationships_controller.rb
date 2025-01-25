class Public::RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    @users = User.all
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    @users = User.all
  end

  def followings
    @post = Post.new
    @user = User.find(params[:user_id])
    @users = @user.followings
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

  def followers
    @post = Post.new
    @user = User.find(params[:user_id])
    @users = @user.followers
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

end
