class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user

  def get_image(width, height)
    return nil unless image.attached?
    image.variant(resize_to_limit: [width, height]).processed
  end
end
