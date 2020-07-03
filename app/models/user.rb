class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presense: true, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/, message: '正しいアドレスを入力してください'}
  validates :password_digest
  validates :description, length: { maximum: 100 }
  validates :identifier_id, presence: true, uniqueness: true, length: { maximum: 20 }, format: { with: /\A[a-zA-z1-9]+\z/, message: '半角英数字のみ使えます' }
end
