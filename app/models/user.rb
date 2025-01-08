class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  has_one_attached :profile_image

  validates :name, presence: true, length: { maximum: 50 }, format: { with: /\A[^\d`!@#$%\^&*+_=]+\z/, message: "に不正な文字が含まれています" }

  def self.search_for(word, method)
    if method == 'perfect_match'
      User.where(name: word)
    elsif method == 'forward_match'
      User.where('name LIKE ?', word + '%')
    elsif method == 'backward_match'
      User.where('name LIKE ?', '%' + word)
    else
      User.where('name LIKE ?', '%' + word + '%')
    end
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/icon_no-image.png')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.png', content_type: 'image/png')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
