class PostComment < ApplicationRecord

  belongs_to :user
  belongs_to :post

  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :comment, presence: true

  after_create do
    notifications.create(user_id: post.user_id) if user_id != post.user_id
  end
end
