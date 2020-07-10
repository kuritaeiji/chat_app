class UniquenessFriendshipValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    user_id = value
    another_user_id = attribute == :requesting_user_id ? record.requested_user_id : record.requesting_user_id # attribute（からむ）と逆のuser_idを取得
    if Friendship.find_by("requesting_user_id = (:requesting_user_id) and requested_user_id = (:requested_user_id)", requesting_user_id: user_id, requested_user_id: another_user_id) || Friendship.find_by("requesting_user_id = (:requesting_user_id) and requested_user_id = (:requested_user_id)", requesting_user_id: another_user_id, requested_user_id: user_id)
      record.errors[:attribute] << '既に友達申請もしくは登録しています。'
    end
  end
end