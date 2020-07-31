class Group < ApplicationRecord
  attr_accessor :avatar_url
  attr_accessor :unread_messages_count_by_group

  has_many :members, dependent: :destroy
  has_many :users, through: :members

  has_many :messages, dependent: :destroy

  has_one_attached :avatar

  validates :name, presence: true, length: { maximum: 20 }
  validates :avatar, image_extension: true

  include Imageable

  def return_user_ids
    members.map(&:user_id)
  end

  def set_unread_messages_count_by_group(user)
    last_read_time = Member.find_by(user_id: user.id, group_id: id).last_read_time
    self.unread_messages_count_by_group = Message.where(group_id: id).where("created_at > (?) AND NOT user_id = ?", last_read_time, user.id).count
  end
end
