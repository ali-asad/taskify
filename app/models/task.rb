class Task < ApplicationRecord
  belongs_to :user, optional: true

  has_many :comments, dependent: :destroy

  private

  def set_default_values
    self.your_field ||= 'default_value'
  end
end
