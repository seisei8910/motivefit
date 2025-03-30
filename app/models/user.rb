class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # フォローしている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  # フォローされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # フォローしているユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed

  # フォロワーを取得
  has_many :followers, through: :passive_relationships, source: :follower

  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end

  has_one_attached :profile_image

  validates :name,
    presence: true, length: { maximum: 50 },
    format: { with: /\A[^\d`!@#$%\^&*+_=]+\z/,
    message: "に不正な文字が含まれています" }
  validates :email,
    format: { with: Devise.email_regexp },
    presence: true,
    uniqueness: { case_insensitive: true }

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

  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end
end
