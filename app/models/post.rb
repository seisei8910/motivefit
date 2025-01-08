class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user

  validates :fitness_date, presence: true
  validates :menu, presence: true

  def self.search_for(word, method)
    if method == 'perfect_match'
      Book.where(title: word)
    elsif method == 'forward_match'
      Book.where('name LIKE ?', word + '%')
    elsif method == 'backward_match'
      Book.where('name LIKE ?', '%' + word)
    else
      Book.where('name LIKE ?', '%' + word + '%')
    end
  end

  def get_image(width, height)
    return nil unless image.attached?
    image.variant(resize_to_limit: [width, height]).processed
  end
end
