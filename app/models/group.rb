class Group < ApplicationRecord
  attr_accessor :avatar_url

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 20 }
  validates :avatar, image_extension: true

  include Imageable

  def return_user_ids
    members.map(&:user_id)
  end
end
