class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user

  validates :fitness_date, presence: true
  validates :menu, presence: true

  def get_image(width, height)
    return nil unless image.attached?
    image.variant(resize_to_limit: [width, height]).processed
  end
end
