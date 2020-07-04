class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/, message: 'は正しいアドレスを入力してください'}
  validates :description, length: { maximum: 100 }
  validates :identifier_id, presence: true, uniqueness: true, length: { maximum: 20 }, format: { with: /\A[a-zA-z1-9]+\z/, message: 'は半角英数字のみ使えます' }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  has_one_attached :avatar
  include Imageable
end
