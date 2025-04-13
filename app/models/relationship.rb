class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :follower_id, uniqueness: { scope: :followed_id, message: "この組み合わせはすでに存在します" }

  after_create do
    notifications.create(user_id: followed.id)
  end
end
