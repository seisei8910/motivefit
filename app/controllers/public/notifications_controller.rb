class Public::NotificationsController < ApplicationController

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    # 通知の種類によるリダイレクトパスの生成
    case notification.notifiable_type
    when "Post"
      redirect_to post_path(notification.notifiable)
    when "Message"
      redirect_to room_path(notification.notifiable)
    when "Post_comment"
      redirect_to post_path(notification.notifiable)
    when "Relationship"
      redirect_to user_path(notification.notifiable.user)
    else
      redirect_to user_path(notification.notifiable.user)
    end
  end

end
