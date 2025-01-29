class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post

  has_one :notification, as: :notifiable, dependent: :destroy

  validates :user_id, uniqueness: {scope: :post_id}

  after_create do
    create_notification(user_id: post.user_id) if user_id != post.user_id
  end

end
