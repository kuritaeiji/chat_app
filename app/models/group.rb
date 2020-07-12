class Group < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :users, through: :members

  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 20 }
  validates :avatar, image_extension: true
end
