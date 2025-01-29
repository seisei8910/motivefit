class Message < ApplicationRecord
  validates :message, presence: true
  belongs_to :user
  belongs_to :room

  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create do
    recipient_id = room.participants.where.not(user_id: user.id).pluck(:user_id).first
    notifications.create(user_id: recipient_id)
  end
end
