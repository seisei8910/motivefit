class Message < ApplicationRecord
  validates :message, presence: true
  belongs_to :user
  belongs_to :room

  has_many :notifications, as: :notifiable, dependent: :destroy

  after_create do
    recipient_id = participants.where.not(user_id: current_user.id).pluck(:user_id).first
    create_notification(user_id: recipient_id)
  end
end
