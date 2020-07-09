class User < ApplicationRecord
  attr_accessor :activation_token, :encoded_avatar

  has_many :requesting_friendships, class_name: 'Friendship', foreign_key: 'requesting_user_id', dependent: :destroy # 友達申請した側のユーザーの中間テーブル
  has_many :requesting_friends, through: :requesting_friendships, source: :requested_user # 自分から友達申請して友達になった友達

  has_many :requested_friendships, class_name: 'Friendship', foreign_key: 'requested_user_id', dependent: :destroy # 友達申請された側のユーザーの中間テーブル
  has_many :requested_friends, through: :requested_friendships, source: :requesting_user # 友達申請されて友達になった友達

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/, message: 'は正しいアドレスを入力してください'}
  validates :description, length: { maximum: 100 }
  validates :identifier_id, presence: true, uniqueness: true, length: { maximum: 20 }, format: { with: /\A[a-z0-9]+\z/i, message: 'は半角英数字のみ使えます' }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  has_one_attached :avatar
  include Imageable

  def create_activation_token_and_digest
    self.activation_token = SecureRandom.base64
    update_attribute(:activation_digest, BCrypt::Password.create(activation_token))
  end

  def friends
    requesting_user_ids = requesting_friendships.select{ |friend| friend.approved }.map(&:requested_user_id)
    requested_user_ids = requested_friendships.select{ |friend| friend.approved }.map(&:requesting_user_id)
    friend_ids = requesting_user_ids.push(requested_user_ids).flatten
    User.where("id in (?)", friend_ids)
  end

  def users_applying_for_friends_to_me
    user_ids_applying_for_friends_to_me = requested_friendships.where(approved: false).map(&:requesting_user_id)
    User.where("id in (?)", user_ids_applying_for_friends_to_me)
  end

  def users_count_applying_for_friends_to_me
    requested_friendships.where(approved: false).count
  end

  def apply_for_friend_to(other_user)
    friendship = Friendship.new(requesting_user_id: id, requested_user_id: other_user.id)
    friendship.save
  end

  def approve_friend_from(other_user)
    requested_friendships.find_by(requesting_user_id: other_user.id).update_attribute(:approved, true)
  end

  def delete_friend(other_user)
    if (deleting_user = requesting_friendships.find{ |friendship| friendship.requested_user_id == other_user.id } || requested_friendships.find{ |friendship| friendship.requesting_user_id == other_user.id })
      deleting_user.destroy
    end
  end
end
