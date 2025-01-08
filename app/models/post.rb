class Post < ApplicationRecord
  has_one_attached :image

  belongs_to :user

  validates :fitness_date, presence: true
  validates :menu, presence: true

  def self.search_for(word, method)
    if method == 'perfect_match'
      Post.where("menu or body ", word, word)
    elsif method == 'forward_match'
      Post.where('menu LIKE ? or body LIKE ?', word + '%', word + '%')
    elsif method == 'backward_match'
      Post.where('menu LIKE ? or body LIKE ?', '%' + word, '%' + word)
    else
      Post.where('menu LIKE ? or body LIKE ?', '%' + word + '%', '%' + word + '%')
    end
  end

  def get_image(width, height)
    return nil unless image.attached?
    image.variant(resize_to_limit: [width, height]).processed
  end
end
