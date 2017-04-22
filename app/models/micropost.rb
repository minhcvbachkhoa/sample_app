class Micropost < ApplicationRecord
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  scope :micropost_ordered, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, I18n.t("warning-max-size")
    end
  end
end
