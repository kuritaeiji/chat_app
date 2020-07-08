class Friendship < ApplicationRecord
  belongs_to :requesting_user, class_name: 'User'
  belongs_to :requested_user, class_name: 'User'

  validates :requesting_user_id, uniqueness_friendship: true 
end
