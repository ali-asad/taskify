class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  has_one_attached :image

  validates :body, presence: true

  def thumbnail
    image.variant(resize_to_limit: [600, 600])
  end

end
