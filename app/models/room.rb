class Room < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :messages, dependent: :destroy
end
