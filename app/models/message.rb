class Message < ApplicationRecord
  attr_accessor :avatar_url
  has_one_attached :avatar

  belongs_to :user
  belongs_to :group

  validates :content, length: { maximum: 200 }

  include Imageable
end
