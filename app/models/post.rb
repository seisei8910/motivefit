class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/photo_no-image.png')
      image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
end
