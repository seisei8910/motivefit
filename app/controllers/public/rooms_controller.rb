class Public::RoomsController < ApplicationController
  def create
    @room = Room.create
    @current_participant = @room.participants.create(user_id: current_user.id)
    @another_participant = @room.participants.create(user_id: params[:participant][:user_id])
    redirect_to room_path(@room)
  end

  def index
    @user = User.find(current_user.id)
    my_room_id = current_user.participants.pluck(:room_id)
    @another_participants = Participant
                            .where(room_id: my_room_id)
                            .where.not(user_id: current_user.id)
                            .preload(room: :messages)
                            .page(params[:page])
  end

  def show
    @user = User.find(current_user.id)
    my_room_id = current_user.participants.pluck(:room_id)
    @another_participants = Participant
                            .where(room_id: my_room_id)
                            .where.not(user_id: current_user.id)
                            .preload(room: :messages)
                            .page(params[:page])
    @room = Room.find(params[:id])
    if @room.participants.where(user_id: current_user.id).present?
      @messages = @room.messages.all
      @message = Message.new
      @participants = @room.participants
      @another_participant = @participants.where.not(user_id: current_user.id).first
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
