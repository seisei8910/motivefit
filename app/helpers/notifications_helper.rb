module NotificationsHelper

  def notification_message(notification)
    case notification.notifiable_type
    when "Post"
      "フォローしている#{notification.notifiable.user.name}さんが新しい投稿をしました！"
    when "Message"
      "#{notification.notifiable.user.name}さんからメッセージが届きました！確認してみましょう！"
    when "PostComment"
      "あなたの投稿に#{notification.notifiable.user.name}さんからコメントされました！"
    when "Relationship"
      "新しいフォロワー#{notification.notifiable.follower.name}さんがあなたをフォローしました！"
    else
      "あなたの投稿が#{notification.notifiable.user.name}さんにいいねされました！"
    end
  end

end
