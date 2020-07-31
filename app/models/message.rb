class Message < ApplicationRecord
  attr_accessor :avatar_url
  has_one_attached :avatar

  belongs_to :user
  belongs_to :group

  validates :content, length: { maximum: 200 }

  include Imageable

  def created_at_to_string
    if created_at.year == Time.zone.now.year
      if created_at.day == Time.zone.now.day
        created_at.strftime('%H:%M:%S')
      else
        created_at.strftime('%m月%d日 %H:%M:%S')
      end
    else
      created_at.strftime('%Y年%m月%d日 %H:%M:%S')
    end
  end
end
