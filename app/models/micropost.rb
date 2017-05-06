class Micropost < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  scope :order_by_created_at, ->{order created_at: :desc}
  scope :microposts_feed, ->user{where user_id: user.following_ids << user.id}

  mount_uploader :picture, PictureUploader

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, I18n.t("warning-max-size")
    end
  end
end
